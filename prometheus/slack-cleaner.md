## Usage

```bash
# Delete all messages from a channel
slack-cleaner --token <TOKEN> --message --channel general --user "*"

# Delete all messages from a private group aka private channel
slack-cleaner --token <TOKEN> --message --group hr --user "*"

# Delete all messages from a direct message channel
slack-cleaner --token <TOKEN> --message --direct sherry --user johndoe

# Delete all messages from a multiparty direct message channel. Note that the
# list of usernames must contains yourself
slack-cleaner --token <TOKEN> --message --mpdirect sherry,james,johndoe --user "*"

# Delete all messages from certain user
slack-cleaner --token <TOKEN> --message --channel gossip --user johndoe

# Delete all messages from bots (especially flooding CI updates)
slack-cleaner --token <TOKEN> --message --channel auto-build --bot

# Delete all messages older than 2015/09/19
slack-cleaner --token <TOKEN> --message --channel general --user "*" --before 20150919

# Delete all files
slack-cleaner --token <TOKEN> --file --user "*"

# Delete all files from certain user
slack-cleaner --token <TOKEN> --file --user johndoe

# Delete all snippets and images
slack-cleaner --token <TOKEN> --file --types snippets,images

# Show information about users, channels:
slack-cleaner --token <TOKEN> --info

# Delete matching a regexp pattern
slack-cleaner --token <TOKEN> --pattern "(bar|foo.+)"

# TODO add add keep_pinned example, add quiet

# Always have a look at help message
slack-cleaner --help
```
