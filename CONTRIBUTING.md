# CONTRIBUTING

Discussion about code base improvements happens in GitHub issues and on pull requests.

- [Contributor Workflow](#contributor-workflow)
- [Sync your fork](#sync-your-fork)

## Contributor Workflow

To contribute a patch, the workflow is as follows:

- Fork repository
- Create topic branch
- Commit patches
- Push changes to your fork
- Create pull request

If a commit references an issue, please add the reference.
For example: `refs #321` or `fixes #12`. Using the `fixes` or
`closes` keywords will cause the applicable issue to be closed
when the pull request is merged.

## Sync your fork

Refer to the GitHub help article on **[Syncing a fork](https://help.github.com/articles/syncing-a-fork/)**.

```
git checkout master
git fetch upstream
git merge upstream/master
git push
```
