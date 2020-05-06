# LazyRecord

LazyRecord is the simplest and laziest implementation of the ActiveRecord pattern, but without
the database, nor the relationships (I said it was a lazy implementation).

Instead of a database, it uses the file based data storage [PStore](https://ruby-doc.org/stdlib-2.5.3/libdoc/pstore/rdoc/PStore.html).

LazyRecord is a teaching tool for the M of MVC, it allows to have models that
have persistence, without having knowledge of SQL.

## Installation

`gem install lazyrecord`

## Usage

To create a model, inherit from `LazyRecord`.

You can add properties as you do with any class.

```ruby
class Post < LazyRecord
  def initialize(title:, body:)
    @title = title
    @body = body
  end
end
```

Now you can create `Post` that have a `#save` method to persist them to 
the database.

```ruby
post = Post.new(title: "LazyRecord is the new ActiveRecord replacement", body: "Says no one")
post.save
puts post.id # The post has an id now
```

You can also use the `#create` shortcut to generate the object and save it

```ruby
post = Post.create(title: "LazyRecord is the new ActiveRecord replacement", body: "Says no one")
puts post.id # The post has an id now
```

You can find a record by id.

```ruby
post = Post.find(1)
```

You can get all the posts as an array:

```ruby
posts = Post.all
```

You can find records by passing a block to `find` (it works exactly the
same as [Array#find](https://ruby-doc.org/core-2.7.1/Enumerable.html#method-i-find))

Since the class method `::all` returns all the elements as an array, you
can do any operation that `Arrays` allow.

```ruby
posts = Post.all

posts.sort_by { |post| post.title } # Also posts.sort_by(&:title)
posts.filter { |post| post.title.match? /LazyRecord/ }
# And so on...
```

## FAQ

### Should I use LazyRecord in production?

If you want to keep your job, no.

### Should I use LazyRecord as a teaching tool before using ActiveRecord?

Sure!

### Will LazyRecord be the new ActiveRecord? 

Maybe!