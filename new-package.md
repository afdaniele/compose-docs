# Create new package

This page will guide you through how to create a new package in **\\compose\\**.

For the sake of ease, we will create a new package called `my_package` in this
section. We will use this name multiple times, but it is not a reserved name,
feel free to replace it with whatever you prefer. Also, remember that **\\compose\\**
comes with only one package pre-installed called `core`. Therefore, you cannot
use this name.


## Table of contents

[toc]


## Prerequisites

It is important that you are familiar with the concepts explained in the
section [Packages](packages) of the documentation. In particular, it is
important to be familiar with the structure of a package, as explained
in [Packages->PACKAGE_ROOT structure](packages#package_root-structure).

Also, this section relies extensively on special directories and
terminology explained in the section
[Important directories and terminology](index#important-directories-and-terminology).
Please, take your time to check it out if you haven't done it already.
The most important ones for this tutorial are the following:
- `SERVER_HOSTNAME`: This is the hostname of the server hosting **\\compose\\** (or `localhost`);
- `COMPOSE_ROOT`: Directory where **\\compose\\** is installed;
- `PACKAGES_DIR`: Defined as `COMPOSE_ROOT/public_html/system/packages/`;
- `PACKAGE_ROOT`: Defined as `PACKAGES_DIR/my_package/`;


## (Optional) Developer Package

One of the main goals of **\\compose\\** is that of being a user-friendly
CMS in the sense that everybody who develops with it, always knows what is
happening under the hood.
In this spirit, we are not going to tell you to copy a bunch of files in a new
place and some magic will happen. Instead, we will guide you through the
creation of each single file you need to define a new package, and in the process
we will explain why we designed it to be that way.

If you don't feel like learning new stuff or you just want to skip ahead, there
is a **Developer** package on the **Package Store** that you can install, which
will help you create new packages and pages from your browser.
Feel free to check it out.


## Where does my new package go?

In order to create a new package `my_package`, we need to create its directory
inside `PACKAGES_DIR`.<br/>
Open a terminal, move to `PACKAGES_DIR` and run the following commands,

```shell
mkdir my_package
cd my_package
```

We just created the directory `PACKAGE_ROOT` for our new package `my_package`.
This is still not a package for **\\compose\\**. In fact, we still need to
tell **\\compose\\** that this directory is in fact a new package.
We can do this by creating a new JSON file inside `PACKAGE_ROOT` called
`metadata.json`. Feel free to use any text-editor to do this. The minimal
package metadata file contains the following fields:

```json
{
  "name": "My Package",
  "description": "A test package"
}
```

It is very important to distinguish between the ID of a package and its name.
The name of the directory containing the package defines its **ID**
(`my_package` in this case),
the value of the field `name` in the file `metadata.json`
(*My Package* in this case) defines its **Name**.

Packages in **\\compose\\** are always referenced by their IDs, never by their
names. The name of a package can change overnight and everything is expected
to keep working fine, its ID must remain unchanged.

You can now copy the text from the snippet above into your newly created
`metadata.json` file.


## Test the new package

You can now open your browser and navigate to `http://SERVER_HOSTNAME/`.
Login if requested and go to the **Settings** page, section **Packages**.
You will see your new package in the list.
If you don't see it, make sure that the cache is disabled by opening
the tab **General** in the **Settings** page. Remember to keep the cache
disabled during development.

If all you want to do next is create a page for your new package, you can
skip to the next section [Create new page](new-page).

Keep reading this page if you want to learn more about what you can do
with your new package in **\\compose\\**.


## Metadata file

We saw above that we need two fields in the metadata file to define a new package.
Even though the minimal configuration for a package is small, the metadata file
supports the definition of quite a few parameters. We will see them in the next
sections.

(Optional): Check out the page
[Package Metadata Requirements](standards#package-metadata-requirements)
to learn more about the package metadata files.


## Configurable parameters

The ultimate goal is that of developing a package that we can share with
everybody else over the internet (more on this in the upcoming section
[Publish your package](#publish-your-package)). This requires our package
to be able to adapt to different use cases. For example, if you are developing
a package that lets a user connect to a MySQL database and retrieve data,
you might want to give the user the option to set the hostname of the
server, the name of the database, etc.
This can be done in **\\compose\\** by using *configurable parameters*.

First of all, we need to tell **\\compose\\** that we want to declare
some parameters and provide some additional information about them
(for example, the type of values that each parameter can accept).
Parameters are defined by the package, not by a page, and they are
defined in the file `PACKAGE_ROOT/configuration/metadata.json`.


### Define configurable parameters

Open a terminal and run the following commands,

```shell
cd PACKAGE_ROOT/
mkdir configuration
cd configuration
```

Use the text-editor you prefer to create the file `metadata.json` and
place the following content in it:

```json
{
  "configuration_content" : {
    "my_text_parameter" : {
      "title" : "My Parameter 1",
      "type" : "text",
      "default" : null,
      "details" : "A magic parameter for my project"
    },
    "my_boolean_parameter" : {
      "title" : "My Parameter 2",
      "type" : "boolean",
      "default" : true,
      "details" : "Another magic parameter for my project"
    }
  }
}
```

The snippet above defines two configurable parameters, `my_text_parameter` and
`my_boolean_parameter`, of type `text` (string) and `boolean` respectively.
Also, we are telling **\\compose\\** that if the user does not change them, their
default values are `null` and `true` respectively.
Save the file, open the browser and navigate to the url where your local
copy of **\\compose\\** is installed.

**\\compose\\** uses a cache system to speed up your application. This means
that some files are not read from disk every time you reload a page, but
fetched from a cache if they were cached before. This is true for configurable
parameters as well. Go to the page **Settings**, **Cache** tab and click on
**Clear cache**. Wait for the page to refresh.

You should be able to see a new tab in the Settings page that reads
<span class="keystroke"><i class="fa fa-cube" aria-hidden="true"></i> Package: <b>My Package</b></span>.
Click on it and you should be able to see the two parameters you just
defined. You can now use this tab to change the parameters for your package.

NOTE: When you change the value of your parameters using the Settings page,
**\\compose\\** will automatically clear the cache for you.


### Read the value of a parameter

Use the function
[Core::getSetting()](classsystem_1_1classes_1_1_core#aafc1c79d1179abd8d5c906a51809344e)
to access the value of your parameters.
For example, you can access the value of the parameter `my_text_parameter`
defined by the package `my_package` using the code,

```php
use \system\classes\Core;
$param_value = Core::getSetting("my_text_parameter", "my_package");
```


### Set the value of a parameter

Use the function
[Core::setSetting()](classsystem_1_1classes_1_1_core#a251526b0d90564e1b4be318dfe724b9d)
to set the value of your parameters.
For example, you can assign the value `"Welcome!"` to the parameter
`my_text_parameter` defined by the package `my_package` using the code,

```php
use \system\classes\Core;
Core::setSetting("my_package", "my_text_parameter", "Welcome!");
```


## Publish your package

Now that we have a new package, we want all our friends to be able to use it.
Packages in **\\compose\\** are shared using `git`. Each package goes in
a separate git repository. The package store in **\\compose\\** installs
new packages by cloning the corresponding repository in `PACKAGES_DIR`.

In order for your package to be accessible via the package store, your
package has to be **public** and hosted on a **public index**.<br/>
**\\compose\\** supports both [GitHub](https://www.github.com) and
[BitBucket](https://www.bitbucket.org).

Login on GitHub or BitBucket and create a public repository.

NOTE: It is not mandatory that the repository name follows a
specific naming convention, but we suggest using the format
**compose-pkg-PACKAGE**, where you replace **PACKAGE** with the
package ID.

In this example, we will assume that the repository name is
**compose-pkg-my\_package**, it is hosted on GitHub, and it is owned
by the user **my\_username**. The URL to your repository would in this case be
`https://github.com/my_username/compose-pkg-my_package`.

Open a terminal, move to the directory `PACKAGE_ROOT` of the package
that you want to publish (`PACKAGES_DIR/my_package` in this case), and run the
following commands,

```shell
git init
git remote add origin https://github.com/my_username/compose-pkg-my_package
git add ./*
git commit -m "first commit"
git push origin master
```

This will tell **git** that:
- this package is now a repository (`git init`);
- the remote repository is hosted at a certain URL (`git remote add origin ...`);
- every file in the package should be included in the repository (`git add/commit ...`);
- we want to transfer our files to the remote repository (`git push ...`);

Your package is now ready to be used by other people.<br/>But, how do we let people know
about this new awesome package? The answer is: **\\compose\\ Package Store**.

The package store is a tool used to discover and install packages that are
publicly available on the internet.
The package store gets the list of packages from a public registry hosted on GitHub
by the repository
[afdaniele/compose-assets-store](https://github.com/afdaniele/compose-assets-store/).

Now that we have a public package, we need to add it to the registry so that everybody
can find it in the package store. For security reasons, we don't let everybody
modify the registry, instead, we ask developers to submit a change (pull) request,
that we will approve and propagate to the public registry.

The procedure for doing this is quite simple, and it comprises of three steps.
1. we make a copy of the registry;
2. we add our new package to it;
3. we submit the new registry for approval;

### Step 1: Fork the registry

Go to
[https://github.com/afdaniele/compose-assets-store](https://github.com/afdaniele/compose-assets-store/)
and click on the
<span class="keystroke"> <i class="fa fa-code-fork" aria-hidden="true"></i> Fork</span>
button in the top-right corner of the page.

This will create a copy of the registry in your personal account.
Follow the instructions and you will be redirected to a page with a URL
that looks like the following.

```shell
https://github.com/USERNAME/compose-assets-store
```

where `USERNAME` will be replaced with your GitHub username.


### Step 2: Add your package

Now that we have our copy of the registry, we can add our package.
Open a terminal and run the following commands (remember to replace
`USERNAME` with your GitHub username),

```shell
cd ~/
git clone https://github.com/USERNAME/compose-assets-store
cd compose-assets-store/
```

Use your preferred text-editor to modify the file `./index` contained in
this directory.
Move to the bottom of the file and add the following block:

```yaml
  - id: PACKAGE_ID
    name: "PACKAGE_NAME"
    git_provider: GIT_PROVIDER
    git_owner: GIT_OWNER
    git_repository: compose-pkg-PACKAGE_ID
    git_branch: master
    icon: "images/_default.png"
    description: "PACKAGE_DESCRIPTION"
    dependencies: []
```

Replace the following placeholders in the block above with the right
information about your package.

- `PACKAGE_ID`: the ID of your package (e.g., `my_package`);
- `PACKAGE_NAME`: the name of your package as set in the file `PACKAGE_ROOT/metadata.json`;
- `GIT_PROVIDER`: this field can have two values, `github.com` or `bitbucket.org`.
  It indicates which websites hosts your package repository;
- `GIT_OWNER`: your username on GitHub or BitBucket;
- `PACKAGE_DESCRIPTION`: the description of your package as set in the
  file `PACKAGE_ROOT/metadata.json`;

Save the changes to the file `index` and run the following commands:

```shell
git commit -m "added new package" index
git push --all origin
```

### Step 3: Create a Pull Request

Now that we updated our copy of the registry, we can submit the change
for approval. Open the URL
[https://github.com/USERNAME/compose-assets-store](#),
click on the button that reads
<span class="keystroke"><i class="fa fa-code-fork" aria-hidden="true"></i> Pull Request</span>,
and follow the instructions to create a **Pull Request**.

We will review your Pull Request and apply your changes to the public registry
as soon as possible.
