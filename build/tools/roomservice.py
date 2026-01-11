#!/usr/bin/env python3
# Copyright (C) 2012-2013, The CyanogenMod Project
#           (C) 2017-2018,2020-2021, The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from __future__ import print_function

import glob
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.parse
import urllib.request

from xml.etree import ElementTree

def github_request(url):
    req = urllib.request.Request(url)
    token = os.getenv("GITHUB_TOKEN")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    req.add_header("Accept", "application/vnd.github+json")
    return req


dryrun = os.getenv('ROOMSERVICE_DRYRUN') == "true"
if dryrun:
    print("Dry run roomservice, no change will be made.")

product = sys.argv[1]

if len(sys.argv) > 2:
    depsonly = sys.argv[2]
else:
    depsonly = None

try:
    device = product[product.index("_") + 1:]
except:
    device = product

if not depsonly:
    print("Device %s not found. Attempting to retrieve device repository from MistOS-Devices Github (http://github.com/MistOS-Devices)." % device)

repositories = []

if not depsonly:
    queries = [
        f"device_{device} user:MistOS-Devices",
        f"android_device_{device} user:MistOS-Devices",
    ]

    seen = set()

    for q in queries:
        url = "https://api.github.com/search/repositories?q=" + urllib.parse.quote(q)

        try:
            githubreq = github_request(url)
            data = json.loads(urllib.request.urlopen(githubreq, timeout=15).read().decode())
        except urllib.error.HTTPError as e:
            print("GitHub HTTP error:", e.code, e.reason)
            continue
        except urllib.error.URLError as e:
            print("GitHub URL error:", e.reason)
            continue

        for item in data.get("items", []):
            name = item["name"]
            if name not in seen:
                repositories.append(name)
                seen.add(name)

local_manifests = r'.repo/local_manifests'
if not os.path.exists(local_manifests): os.makedirs(local_manifests)

def exists_in_tree(lm, path):
    for child in lm.getchildren():
        if child.attrib['path'] == path:
            return True
    return False

# in-place prettyprint formatter
def indent(elem, level=0):
    i = "\n" + level*"  "
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + "  "
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
        for elem in elem:
            indent(elem, level+1)
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = i

def get_manifest_path():
    '''Find the current manifest path
    In old versions of repo this is at .repo/manifest.xml
    In new versions, .repo/manifest.xml includes an include
    to some arbitrary file in .repo/manifests'''

    m = ElementTree.parse(".repo/manifest.xml")
    try:
        m.findall('default')[0]
        return '.repo/manifest.xml'
    except IndexError:
        return ".repo/manifests/{}".format(m.find("include").get("name"))

def get_default_revision():
    m = ElementTree.parse(get_manifest_path())
    d = m.findall('default')[0]
    r = d.get('revision')
    return r.replace('refs/heads/', '').replace('refs/tags/', '')

def get_from_manifest(devicename):
    for path in glob.glob(".repo/local_manifests/*.xml"):
        try:
            lm = ElementTree.parse(path)
            lm = lm.getroot()
        except:
            lm = ElementTree.Element("manifest")

        for localpath in lm.findall("project"):
            if re.search(r"(android_)?device_.*_%s$" % device, localpath.get("name")):
                return localpath.get("path")

    return None

def is_in_manifest(projectpath):
    for path in glob.glob(".repo/local_manifests/*.xml"):
        try:
            lm = ElementTree.parse(path)
            lm = lm.getroot()
        except:
            lm = ElementTree.Element("manifest")

        for localpath in lm.findall("project"):
            if localpath.get("path") == projectpath:
                return True

    # Search in main manifest, too
    try:
        lm = ElementTree.parse(get_manifest_path())
        lm = lm.getroot()
    except:
        lm = ElementTree.Element("manifest")

    for localpath in lm.findall("project"):
        if localpath.get("path") == projectpath:
            return True

    # ... and don't forget the lineage snippet
    try:
        lm = ElementTree.parse(".repo/manifests/snippets/lineage.xml")
        lm = lm.getroot()
    except:
        lm = ElementTree.Element("manifest")

    for localpath in lm.findall("project"):
        if localpath.get("path") == projectpath:
            return True

    return False

def add_to_manifest(repositories):
    if dryrun:
        return

    try:
        lm = ElementTree.parse(".repo/local_manifests/roomservice.xml")
        lm = lm.getroot()
    except:
        lm = ElementTree.Element("manifest")

    for repository in repositories:
        repo_name = repository['repository']
        repo_target = repository['target_path']
        repo_revision = repository['branch']
        print('Checking if %s is fetched from %s' % (repo_target, repo_name))
        if is_in_manifest(repo_target):
            print('MistOS-Devices/%s already fetched to %s' % (repo_name, repo_target))
            continue

        repo_remote = repository.get("remote")
        repo_name_raw = repo_name

        # Determine project name
        if "/" in repo_name_raw:
            # Fully qualified repo (Org/Repo)
            project_name = repo_name_raw
        else:
            # Short repo name → assume MistOS-Devices
            project_name = f"MistOS-Devices/{repo_name_raw}"

        # Determine remote
        project_remote = repo_remote if repo_remote else "github"

        project_attrib = {
            "path": repo_target,
            "remote": project_remote,
            "name": project_name,
        }

        if repo_revision:
            project_attrib["revision"] = repo_revision

        project = ElementTree.Element("project", attrib=project_attrib)

        # aosp remotes special case
        if repo_remote and repo_remote.startswith("aosp-"):
            project.attrib["clone-depth"] = "1"
            project.attrib.pop("revision", None)

        # Drop default revision
        if project.attrib.get("revision") == get_default_revision():
            project.attrib.pop("revision", None)

        print("Adding dependency:", project.attrib["name"], "->", project.attrib["path"])
        lm.append(project)


    indent(lm, 0)
    raw_xml = ElementTree.tostring(lm).decode()
    raw_xml = '<?xml version="1.0" encoding="UTF-8"?>\n' + raw_xml

    f = open('.repo/local_manifests/roomservice.xml', 'w')
    f.write(raw_xml)
    f.close()

def fetch_dependencies(repo_path):
    print('Looking for dependencies in %s' % repo_path)
    dependencies_path = repo_path + '/lineage.dependencies'
    syncable_repos = []
    verify_repos = []

    if os.path.exists(dependencies_path):
        dependencies_file = open(dependencies_path, 'r')
        dependencies = json.loads(dependencies_file.read())
        fetch_list = []

        for dependency in dependencies:
            if not is_in_manifest(dependency['target_path']):
                fetch_list.append(dependency)
                syncable_repos.append(dependency['target_path'])
                if 'branch' not in dependency:
                    if dependency.get('remote', 'github') == 'github':
                        dependency['branch'] = get_default_or_fallback_revision(dependency['repository'])
                        if not dependency['branch']:
                            sys.exit(1)
                    else:
                        dependency['branch'] = None
            verify_repos.append(dependency['target_path'])

            if not os.path.isdir(dependency['target_path']):
                syncable_repos.append(dependency['target_path'])

        dependencies_file.close()

        if len(fetch_list) > 0:
            print('Adding dependencies to manifest')
            add_to_manifest(fetch_list)
    else:
        print('%s has no additional dependencies.' % repo_path)

    if len(syncable_repos) > 0:
        print('Syncing dependencies')
        if not dryrun:
            os.system('repo sync --force-sync %s' % ' '.join(syncable_repos))

    for deprepo in verify_repos:
        fetch_dependencies(deprepo)

def get_default_or_fallback_revision(repo_name):
    default_revision = get_default_revision()
    print("Default revision:", default_revision)
    print("Checking branch info")

    try:
        result = subprocess.run(
            ["git", "ls-remote", "-h", f"https://github.com/MistOS-Devices/{repo_name}"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        stdout = result.stdout.strip()
        branches = [x.split("refs/heads/")[-1] for x in stdout.splitlines()]
    except Exception as e:
        print("git ls-remote failed:", e)
        branches = []

    print("Branches found:", branches)

    # 1️⃣ Prefer default revision if present
    if default_revision in branches:
        return default_revision

    # 2️⃣ TRUST fallback if user explicitly provided it
    fallbacks = os.getenv("ROOMSERVICE_BRANCHES")
    if fallbacks:
        for fallback in fallbacks.split():
            print("Using fallback branch:", fallback)
            return fallback

    print(f"Default revision {default_revision} not found in {repo_name}. Bailing.")
    return ""


if depsonly:
    repo_path = get_from_manifest(device)
    if repo_path:
        fetch_dependencies(repo_path)
    else:
        print("Trying dependencies-only mode on a non-existing device tree?")

    sys.exit()

else:
    for repo_name in repositories:
        if re.match(r"^(android_)?device_[^_]+_" + device + "$", repo_name):
            print("Found repository: %s" % repo_name)
            
            manufacturer = repo_name
            manufacturer = manufacturer.replace("android_device_", "")
            manufacturer = manufacturer.replace("device_", "")
            manufacturer = manufacturer.replace("_" + device, "")
            repo_path = "device/%s/%s" % (manufacturer, device)
            revision = get_default_or_fallback_revision(repo_name)
            if revision == "":
                # Some devices have the same codename but shipped a long time ago and may not have
                # a current branch set up.
                # Continue looking up all repositories until a match is found or no repos are left
                # to check.
                continue

            device_repository = {'repository':repo_name,'target_path':repo_path,'branch':revision}
            add_to_manifest([device_repository])

            print("Syncing repository to retrieve project.")
            os.system('repo sync --force-sync %s' % repo_path)
            print("Repository synced!")

            fetch_dependencies(repo_path)
            print("Done")
            sys.exit()

    # Check the official devices JSON
    url = "https://raw.githubusercontent.com/MistOS-Devices/official_devices/refs/heads/16/buildDevices.json"
    try:
        req = urllib.request.Request(url)
        data = json.loads(urllib.request.urlopen(req, timeout=15).read().decode())
        for dev in data.get("devices", []):
            if dev.get("codename") == device:
                repo_full = dev["repo"]
                repo_name = repo_full.split('/')[-1]
                print("Found repository in official devices: %s" % repo_name)
                
                repo_path = repo_name.replace("android_", "").replace("_", "/")
                revision = get_default_or_fallback_revision(repo_name)
                if revision == "":
                    print("No suitable branch found for %s" % repo_name)
                    break

                device_repository = {'repository':repo_name,'target_path':repo_path,'branch':revision}
                add_to_manifest([device_repository])

                print("Syncing repository to retrieve project.")
                os.system('repo sync --force-sync %s' % repo_path)
                print("Repository synced!")

                fetch_dependencies(repo_path)
                print("Done")
                sys.exit()
    except Exception as e:
        print("Error fetching official devices JSON:", e)

print("Repository for %s not found in the LineageOS Github repository list. If this is in error, you may need to manually add it to your local_manifests/roomservice.xml." % device)
