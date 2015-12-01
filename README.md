# SearchKit

## Description

SearchKit is a Ruby wrapper and CLI toolkit for the SearchKit APIs.  The whole idea is to give folks an easy and pleasant way to include search features in their applications.

## Installation

You can start by installing the gem:

    gem install search-kit

Now set it up, by creating a SearchKit account:

```
$ search-kit setup
--> [ development ]:  Setting up a new SearchKit account
--> [ development ]:
--> [ development ]:  Email:
--> [ development ]:  Password:
```

Put in a name and password which you'd like to use.  Afterward, your
kit will be automatically configured with an API key:

```
--> [ development ]:  Set app_token: <token>
--> [ development ]:  Alright!  Your search-kit install has been set up.
```

This gives you a subscriber account for SearchKit, and an access token which can be used to access the API.  This first token is a creator token, which has universal permissions - don't worry, you can make a consumer (read-only) key later if you're concerned about security.

## Getting Started: Search in five minutes

Building an index is your first major step.  Let's assume you have a collection of documents which look a bit like this:

```json
{
  "body": "Some lorem ipsum",
  "id": "document_1",
  "title": "Blog post"
}
```
### Anatomy and document schema

The `id` field, here, is important.  SearchKit requires the `id` field for all documents, or it will throw a bad request at you.  On the other hand, the `id` isn't necessarily a number - it's stored on our end as a string, and it can be any unique value you can think of.

As far as anatomy goes, a flat, universal representation of what you expect to create is important.  It's easier to understand and navigate through flat JSON than an elaborate nested structure.

Finally, SearchKit has no knowledge of relationships between documents. Because of that, we recommend that you have a clear idea of what you want use you're going to put a particular index to.

### Scaffolding

To quickly create a searchable index using the CLI:

```
$ search-kit scaffolds create "My Blog Posts" '[{
  "body": "Some lorem ipsum",
  "id": "document_1",
  "title": "Blog post"
}]'
```

Here, we're submitting in the form of a raw JSON array - SearchKit will parse the JSON, build an index named "My Blog Posts", and populate it with the given document.

Or, if you just want to use the Ruby client:

```ruby
documents = [{
  body:  "Some lorem ipsum",
  id:    "document_1",
  title: "Blog post"
}]

scaffold = SearchKit::Clients::Scaffold.new
scaffold.create("My Blog Posts", documents)
```

In most cases, the Ruby client attempts to coerce API responses into [Virtus](https://github.com/solnic/virtus) models, so that you'll have access to some nice ruby [barewords](http://devblog.avdi.org/2012/10/01/barewords/) on your response objects.

### Index identity

If you don't want to create and populate an index in one fell stroke, you can do it programmatically or through the CLI.

#### CLI:

```
search-kit indices create "My Blog Posts"
```

#### Ruby

```ruby
indices = SearchKit::Clients::Indices.new
indices.create("My Blog Posts")
```

So you've created an index.  You've given it the name "My Blog Posts".  Now it's out there, linked to your account, accessable by your api token, and it's also been given a distinct uri by turning the name into a `slug`.  A slug is derived from an Index name, and is turned into a uri-friendly string.  It's always given back in the response body of a successful index creation.

In this case, the slug would be `my-blog-posts`.  From here on out, you will pass the slug into SearchKit clients to access that index and its child resources (Documents, Populate, Scaffold, Search).

In other words, to search the index, we want to use its slug:

#### CLI - Searching an index

```
$ search-kit search create my-blog-posts post
```

This gives you back a set of results that look a bit like this:

```
--> [ development ]:  Searching `my-blog-psts` for titles matching `post`:
--> [ development ]:   - Found 1 titles in 9ms
--> [ development ]:   -- document_1 | score: 0.8637942
```

Not too helpful just to get the ID/score back.  Let's get some more information:

```
$ search-kit search create my-blog-posts post -d title
--> [ development ]:  Searching `my-blog-psts` for titles matching `post`:
--> [ development ]:   - Found 1 titles in 9ms
--> [ development ]:   -- Blog post | score: 0.8637942
```

Better!

#### Ruby - Searching an index

```ruby
search = SearchKit::Clients::Search.new
search.create("my-blog-posts", phrase: "post")
```

This one is a great deal friendlier, if you know how to script in Ruby, because it returns a helpful Search model with child document models.

## Overview

From there on out, you have a ton of options - whether through the Ruby CLI, the Ruby bindings which power it, or the raw API, itself.

You have individual, atomic document control with the Document client:

```ruby
# Atomic CRUD on individual documents
#
documents = SearchKit::Clients::Documents.new
documents.create('my-blog-posts', blog_post)
documents.show('my-blog-posts', blog_post_id)
documents.update('my-blog-posts', blog_post_id, blog_post)
documents.delete('my-blog-posts', blog_post)
```

You have batch control with the Populate client:

```ruby
# Batch CRUD
#
populate = SearchKit::Clients::Populate.new
populate.create('my-blog-posts', blog_posts)
populate.update('my-blog-posts', blog_posts)
populate.delete('my-blog-posts', blog_post_ids)
```

And so on.  The various domains of the API will be explained in depth soon.

## One last thing

SearchKit is heavily influenced by the [jsonapi spec](http://jsonapi.org).  All response bodies follow this hypermedia representation, contain resource links, and exist in a data namespace.  It isn't 100% compliant yet, but it is _close_, and it does recognize the API format.  So in other words, if you know how to use or design hypermedia clients, you're in luck.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/qbox-io/search-kit - please don't hesitate!
