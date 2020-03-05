# git_diff_parser

A git diff parser but in Crystal - Ported from [https://github.com/packsaddle/ruby-git_diff_parser](https://github.com/packsaddle/ruby-git_diff_parser)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     git_diff_parser:
       github: microgit-com/git_diff_parser
   ```

2. Run `shards install`

## Usage

```crystal
require "git_diff_parser"
```

### Entirely Git Diff

Then use the patches parse:
```crystal
patches = GitDiffParser::Patches.parse(diff)
```
I added paddlesaddle's `GitDiffParser.parse` method, even if it was deprecated.
So you can use it as well if you want.

### A small diff (commit diff, file diff)
Then use the patch new:
```crystal
patch = GitDiffParser::Patch.new(diff)
```

## Development

I copy more or less everything from paddlesaddle and ported it to crystal. Even the specs. So Run `crystal spec` if you add or change anything to make sure it works :)

## Contributing

1. Fork it (<https://github.com/microgit-com/git_diff_parser/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Håkan Nylén](https://github.com/confact) - creator and maintainer
