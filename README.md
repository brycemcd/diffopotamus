# Diffopotamus

## What it is

A small CSV extraction and diff tool used by me to help extract lists
from Exact Target, compare their attributes and output a diff of the
lists as a CSV

It currently requires quite a bit of customization depending on the list
you're importing.

## Dependencies

You'll need redis installed and the redis gem

## How to Use

* Drop two CSV lists with at least one column in common in the data
directory
* Update the code to reference the two lists
* Update the code to update the hashes that identify the CSV file's
header and any conditional logic to push the CSV row's id to the
comparison list
* run `ruby diffopotamus.rb` and wait for it to complete
* enjoy your new list_diff.csv in the data directory
