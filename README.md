#Portlet and Applet generator. 

There are two important concepts under the .LRN toolkit: Applets and Portlets. 

## Applets

If one wants an application to be available under a community (mounted under the community's site node) then one provides or registers an applet bounded to it. This applet will then allow the programmer to take custom actions (setting up special permissions, creating a custom type of acs object, etc) when the package wants to be added to or removed from the community for example.

## Portlets

.LRN is a portal based system. Each portal is composed of pages, which are composed of portlets. A portlet is a snippet of dinamically generated html that presents information concerning a given application. Depending on the nature of the application the portlet is presenting, it can be shown within a user's portal or a community's portal, or in both when desired. 

The convention so far, within the .LRN community has been to provide separate packages for the application's applet and portlet. The idea behind it is that your application's package should be implemented as general as possible so that one could install and use the package without all the .LRN machinery (communities, portals, etc), i.e. one should be able to use the package in a plain OpenACS installation. Nevertheless, it is currently possible to provide just one package that does the magic of registering an applet and providing a portlet. 

In this case, we stick with what the community has been doing so far: independent packages for the applet and the portlet. 


## Poplet

Poplet is a dead-simple script written in python that will take a couple of arguments and combine them with templates for generate two folders: an applet and a portlet for your OpenACS/.LRN package.

For example, lets assume we have a package named tasks ( with package key : tasks), then we only need to run 

```bash
$> ./poplet --pkg-key=task --author="Victor Guerra" --pkg-name="Task" --pkg-plural="Tasks"
```

To have closer look at the available options: 
```bash
$> ./poplet --help
```
