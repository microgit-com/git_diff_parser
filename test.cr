require "./src/git_diff_parser"
require "logger"

diff = "diff --git a/src/actions/issues/edit.cr b/src/actions/issues/edit.cr
index bfe0936..2210a61 100644
--- a/src/actions/issues/edit.cr
+++ b/src/actions/issues/edit.cr
@@ -1,7 +1,6 @@
 class Repositories::Issues::Edit < BrowserAction
-  include ::RepositoryHelper
-
-  get \"/:namespace_slug/:repository_slug/issues/:issue_id/edit\" do
+  nested_route do
     issue = IssueQuery.find(issue_id)
-    repository = check_access
+    repository = RepositoryQuery.find(repository_id)
+    RepositoryPolicy.show?(repository, current_user, context)
     html EditPage,"

patches = GitDiffParser.parse(diff)
logger = Logger.new(STDOUT)

if !patches.empty?
  patch = patches.first

  logger.info patch.file

  logger.info patch.changed_lines
  logger.info patch.removed_lines
  logger.info patch.body.lines.first
  logger.info patch.changed_line_numbers
  logger.info patch.removed_line_numbers
end
