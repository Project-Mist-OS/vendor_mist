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


# ====================================
# 🔥 Find exsiting project path
# ====================================

def find_project_name_by_path(target_path):
    # Search main manifest + included manifests
    try:
        manifest_paths = []

        # main manifest
        main_manifest = get_manifest_path()
        manifest_paths.append(main_manifest)

        # all included manifests
        manifest_dir = ".repo/manifests"
        for root, _, files in os.walk(manifest_dir):
            for f in files:
                if f.endswith(".xml"):
                    manifest_paths.append(os.path.join(root, f))

        for mpath in manifest_paths:
            try:
                tree = ElementTree.parse(mpath)
                root = tree.getroot()

                for project in root.findall("project"):
                    if project.get("path") == target_path:
                        return project.get("name")
            except:
                continue

    except:
        pass

    return None

# =========================
# 🔥 CUSTOM HELPERS
# =========================

def remove_existing_project_entries(target_path):
    for path in glob.glob(".repo/local_manifests/*.xml"):
        try:
            tree = ElementTree.parse(path)
            root = tree.getroot()
            changed = False

            for project in list(root.findall("project")):
                if project.get("path") == target_path:
                    root.remove(project)
                    changed = True

            if changed:
                tree.write(path)
        except:
            pass


# =========================
# ORIGINAL LOGIC BELOW
# =========================

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
    print("Device %s not found. Attempting to retrieve device repository from MistOS-Devices Github." % device)

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
if not os.path.exists(local_manifests):
    os.makedirs(local_manifests)


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
            lm = ElementTree.parse(path).getroot()
        except:
            lm = ElementTree.Element("manifest")

        for localpath in lm.findall("project"):
            if re.search(r"(android_)?device_.*_%s$" % device, localpath.get("name")):
                return localpath.get("path")
    return None


def is_in_manifest(projectpath):
    # local manifests
    for path in glob.glob(".repo/local_manifests/*.xml"):
        try:
            lm = ElementTree.parse(path).getroot()
        except:
            lm = ElementTree.Element("manifest")

        for localpath in lm.findall("project"):
            if localpath.get("path") == projectpath:
                return True

    # main manifest
    try:
        lm = ElementTree.parse(get_manifest_path()).getroot()
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
        lm = ElementTree.parse(".repo/local_manifests/roomservice.xml").getroot()
    except:
        lm = ElementTree.Element("manifest")

    for repository in repositories:
        repo_name = repository['repository']
        repo_target = repository['target_path']
        repo_revision = repository.get('branch')
        override = repository.get("override", False)

        print(f'Checking {repo_target} (override={override})')

        if override:
            original_name = find_project_name_by_path(repo_target)

            if not original_name:
                print(f"ERROR: Could not find original project for {repo_target}")
                sys.exit(1)

            print(f"Override: removing original project {original_name}")

            # 🔥 CLEAN OLD ENTRIES (both project + remove-project)
            for elem in list(lm):
                if elem.tag in ["project", "remove-project"]:
                    if elem.get("path") == repo_target or elem.get("name") == original_name:
                        lm.remove(elem)

            # 🔥 ADD remove-project ONLY ONCE
            remove = ElementTree.Element("remove-project", attrib={
                "name": original_name
            })
            lm.append(remove)

        else:
            if is_in_manifest(repo_target):
                print(f"{repo_target} already exists, skipping")
                continue

        # ===== ORIGINAL LOGIC CONTINUES =====

        repo_remote = repository.get("remote")
        repo_name_raw = repo_name

        if "/" in repo_name_raw:
            project_name = repo_name_raw
        else:
            project_name = f"MistOS-Devices/{repo_name_raw}"

        project_remote = repo_remote if repo_remote else "github"

        project_attrib = {
            "path": repo_target,
            "remote": project_remote,
            "name": project_name,
        }

        if repo_revision:
            project_attrib["revision"] = repo_revision

        project = ElementTree.Element("project", attrib=project_attrib)

        if project.attrib.get("revision") == get_default_revision():
            project.attrib.pop("revision", None)

        print("Adding:", project.attrib["name"], "->", project.attrib["path"])
        lm.append(project)

    indent(lm)
    raw_xml = '<?xml version="1.0" encoding="UTF-8"?>\n' + ElementTree.tostring(lm).decode()

    with open('.repo/local_manifests/roomservice.xml', 'w') as f:
        f.write(raw_xml)


def fetch_dependencies(repo_path):
    print('Looking for dependencies in %s' % repo_path)

    dependencies_path = repo_path + '/lineage.dependencies'
    syncable_repos = []
    verify_repos = []

    if os.path.exists(dependencies_path):
        dependencies = json.load(open(dependencies_path))
        fetch_list = []

        for dependency in dependencies:
            override = dependency.get("override", False)

            # ✅ ensure branch ALWAYS exists
            if 'branch' not in dependency:
                if dependency.get('remote', 'github') == 'github':
                    dependency['branch'] = get_default_or_fallback_revision(dependency['repository'])
                    if not dependency['branch']:
                        sys.exit(1)
                else:
                    dependency['branch'] = None

            if override:
                print(f"Override requested for {dependency['target_path']}")
                remove_existing_project_entries(dependency['target_path'])
                fetch_list.append(dependency)

                if dependency['target_path'] not in syncable_repos:
                    syncable_repos.append(dependency['target_path'])

            else:
                if not is_in_manifest(dependency['target_path']):
                    fetch_list.append(dependency)

                if not os.path.isdir(dependency['target_path']):
                    if dependency['target_path'] not in syncable_repos:
                        syncable_repos.append(dependency['target_path'])

            verify_repos.append(dependency['target_path'])

        if fetch_list:
            print('Adding dependencies to manifest')
            add_to_manifest(fetch_list)

    else:
        print('%s has no additional dependencies.' % repo_path)

    if syncable_repos and not dryrun:
        print('Syncing dependencies')
        os.system('repo sync --force-sync %s' % ' '.join(syncable_repos))

    for deprepo in verify_repos:
        fetch_dependencies(deprepo)


def get_default_or_fallback_revision(repo_name):
    default_revision = get_default_revision()

    try:
        result = subprocess.run(
            ["git", "ls-remote", "-h", f"https://github.com/MistOS-Devices/{repo_name}"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        branches = [x.split("refs/heads/")[-1] for x in result.stdout.splitlines()]
    except:
        branches = []

    if default_revision in branches:
        return default_revision

    fallbacks = os.getenv("ROOMSERVICE_BRANCHES")
    if fallbacks:
        return fallbacks.split()[0]

    return ""


# =========================
# MAIN
# =========================

if depsonly:
    repo_path = get_from_manifest(device)
    if repo_path:
        fetch_dependencies(repo_path)
    sys.exit()

else:
    for repo_name in repositories:
        if re.match(r"^(android_)?device_[^_]+_" + device + "$", repo_name):
            manufacturer = repo_name.replace("android_device_", "").replace("device_", "").replace("_" + device, "")
            repo_path = f"device/{manufacturer}/{device}"

            revision = get_default_or_fallback_revision(repo_name)
            if not revision:
                continue

            device_repository = {
                'repository': repo_name,
                'target_path': repo_path,
                'branch': revision
            }

            add_to_manifest([device_repository])
            os.system(f'repo sync --force-sync {repo_path}')

            fetch_dependencies(repo_path)
            print("Done")
            sys.exit()
# Fallback: Check official devices JSON
url = "https://raw.githubusercontent.com/MistOS-Devices/official_devices/refs/heads/16/buildDevices.json"

try:
    req = urllib.request.Request(url)
    data = json.loads(urllib.request.urlopen(req, timeout=15).read().decode())

    for dev in data.get("devices", []):
        if dev.get("codename") == device:
            repo_full = dev.get("repo")
            repo_name = repo_full.split('/')[-1]

            print(f"Found repository in official devices: {repo_name}")

            repo_path = repo_name.replace("android_", "").replace("_", "/")

            revision = get_default_or_fallback_revision(repo_name)
            if not revision:
                print(f"No suitable branch found for {repo_name}")
                break

            device_repository = {
                'repository': repo_name,
                'target_path': repo_path,
                'branch': revision
            }

            add_to_manifest([device_repository])
            os.system(f'repo sync --force-sync {repo_path}')

            fetch_dependencies(repo_path)

            print("Done")
            sys.exit()

except Exception as e:
    print("Error fetching official devices JSON:", e)
print(f"Repository for {device} not found.")
