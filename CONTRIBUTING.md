# Contributing

We appreciate contributions of any kind and acknowledge them on our [README][readme].  By participating
in this project, you agree to abide by our [code of conduct](CODE_OF_CONDUCT.md).

## Any enhancements/bugs/etc you see?

Add an issue.  We'll review it, add labels and reply within a few days.

## See an issue you'd like to work on?

Comment on the issue that you'd like to work on it
and we'll add the `claimed` label.  If you see the `claimed` label already on the issue you
might want to ask the contributor if they'd like some help.

## Documentation/etc need updating?

Go right ahead!  Just submit a pull request when you're done.

## Pull Requests

We love pull requests from everyone.

Fork, then clone the repo:

    git clone git@github.com:your-username/ps-alias.git

**All changes should be based from the `vNext` branch.**

- All functions placed in the `src/devtoolbox/Export` folder will be available to the end-user.
- All functions placed in the `src/devtoolbox/Private` folder will only be available to the module's scripts *not* the end-user.

Please follow these steps to include a new function to the module:

1. Create a new function in the `src/devltoolbox/Export` folder.
1. Run the `/UpdateManifest.ps1` to update the manifest.
1. If you have previously installed the module, run `/UninstallModule.ps1`.
1. Run `/InstallModule.ps1` to install the module to your local module folder and test your new function.

Push to your fork and [submit a pull request](https://github.com/builders-club/devtoolbox/compare/) against the `vNext` branch.

At this point you're waiting on us. We like to at least comment on pull requests
within three days (and, typically, one day). We may suggest
some changes or improvements or alternatives.

Normally reviews & merging occur live on stream at [https://twitch.tv/baldbeardedbuilder](https://twitch.tv/baldbeardedbuilder).

Some things that will increase the chance that your pull request is accepted:

- **Update [README][readme] with any needed changes**
- Update [CHANGELOG](CHANGELOG.md) with any changes
- Write a [good commit message](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).

[readme]: README.md
