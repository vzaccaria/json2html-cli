
# json2html-cli

> Converts a bunch of json files into a directory structured by category&#x2F;year&#x2F;month&#x2F;day&#x2F;name of html files

## Usage

```
Usage:
    blog-cli md2json [ input | directory DIR -d DEST ] -t TEMPLATE -c CONFIG 
    blog-cli json2html [ directory -d DEST ] DIR  
    blog-cli json2json [-k CATEGORY] [ -t TEMPLATE -c CONFIG ] DIR  
    blog-cli renderjson -f JSON -t TEMPLATE -c CONFIG 
    blog-cli -v | -h | --help 

Options: 
    -t, --template TEMPLATE   Jade template that expands the `post.contents` 
    -c, --config CONFIG       JSON configuration file of the site (has a `baseUrl` property)
    -d, --destination DEST    Destination directory
    -k, --filter CATEGORY     Filter by category
    -f, --file JSON           Render JSON inside the template

Arguments: 
    DIR         Source directory

```

## Authors
* Vittorio Zaccaria

## License
BSD

***


