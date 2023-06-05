# copy_file_to_another_repo_action
This GitHub Action copies files or folders from the current repository to a location in another repository
 ```diff
   Inspiration from @dmnemec
 + Uses rsync exclusively with full access to it's switches.
 + The rsync_option: makes it very versatile
 + with many configuration settings possible. 
 + If rsync_option: is not used it defaults to "-avrh"
 ! Use with caution!, test with –dry-run before actual commit.
 
 + Multiple source files/directories separated by comma
 + "file1.txt,file2.txt" or '"file 1.txt","file 2.txt"'
 + if there are spaces in the file/folder name(s)
 
 + Use ${{ github.event.head_commit.message }} to 
 + preserve the original commit message.
 
 + git-lfs support.
 ```
 Important **Behavioural Notes** of rsync[^1].
# Example Workflow
```yml
name: Push Files

on: push

jobs:
  copy-files:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Push test folder & 1 file
        uses: dobbelina/multi_file_bandit@main
        env:
          API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}
        with:
          source_file: "My_Folder/,Another_Folder/test.txt"
          destination_repo: "dobbelina/release-test"
          destination_folder: "test-dir" # Omit if destination root
          user_email: "example@email.com"
          user_name: "dobbelina"
          commit_message: ${{ github.event.head_commit.message }}
          rsync_option: "-avrh --delete" # Deletes any files in the 
                                         # destination that is not
                                         # present in the source 
 ```
# Variables

The `API_TOKEN_GITHUB` needs to be set in the `Secrets` section of your repository options. You can retrieve the `API_TOKEN_GITHUB` [here](https://github.com/settings/tokens) (set the `repo` permissions). Fine-grained personal access tokens are much more secure as you can set
access to only choosen repositories, You need Actions & Contents set to **Access: Read and write** & Metadata **Access: Read-only**

* source_file: The file(s) or directory/directories to be moved. Uses the same syntax as the `rsync` command. Include the path for any files not in the repositories root directory. Multiple source files/directories separated by comma 
`"file1.txt,file2.txt"` or `'"file 1.txt","file 2.txt"'` if there are spaces in the file/folder name(s)
* destination_repo: The repository to place the file or directory in.
* destination_folder: [optional] The folder in the destination repository to place the file in, if not the root directory.
* user_email: The GitHub user email associated with the API token secret.
* user_name: The GitHub username associated with the API token secret.
* destination_branch: [optional] The branch of the source repo to update, if not "main" branch is used.
* destination_branch_create: [optional] A branch to be created with this commit, defaults to commiting in `destination_branch`
* commit_message: [optional] A custom commit message for the commit. Defaults to `Update from https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}` 
 use `${{ github.event.head_commit.message }}` to preserve the original commit message.
* rsync_option: [optional] Full access to rsync's switches, if not used it defaults to "-avrh"
* retry_attempts: [optional] Retry attempts if pushing commit failed, if not used it defaults to 10
* git_server: [optional] Git server host, default github.com

## Behavioural Notes
[^1]: `Source_Folder` _rsync_ will copy the folder.  
 `Source_Folder/` with a trailing slash _rsync_ will only copy the contents of the folder.  
 `Source_Folder/*` with a trailing slash and an asterisk _rsync_ will only copy the contents   
 of the folder but without any hidden files or hidden subfolders.  
 The asterisk `*` will **expand all files in** `Source_Folder/*` **except the files 
 and subfolders whose name starts with a dot** (hidden files or hidden subfolders).
