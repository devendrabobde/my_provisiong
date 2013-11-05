Ruby on Rails Console
=====================

Reference: http://guides.rubyonrails.org/command_line.html

The Rails console allows you interact with your application from the
command line.

To start the rails console, enter the following at a command line from
within the root directory:
`rails console production`

This will start the console. You'll see something like this:
```
$ rails console production
Loading production environment (Rails 3.2.12)
irb(main):001:0>
```

From here, you will be able to interact with the application as desired.

To count Ois's:
```
irb(main):001:0> Ois.count
=> 10
```

To find a particular OisClientPreference:
```
irb(main):001:0> OisClientPreference.find_by_slug('onestop-default')
=> #<OisClientPreference id: "c38949cd-e588-4588-a68d-8ef543c9ab0e",
preference_name: "OneStop Default", faq_url:
"http://www.drfirst.com/onestop/faq", help_url:
"http://www.drfirst.com/onestop/help", logo_url:
"http://www.drfirst.com/onestop/logo.png", slug: "onestop-default",
creatorid: nil, lastupdateid: nil, createddate: "2013-02-21 21:26:20",
lastupdatedate: "2013-02-21 21:26:20", createddate_as_number:
20130221212620, lastupdatedate_as_number: 20130221212620, client_name:
"OneStop">
```

To undelete a record, you'll need to know the id for easy retreival.
For example purposes, we will be using a User with an id of
`eef1664e-f087-44c1-8bb3-003b88252d89`.

First, verify the item is deleted:
```
user = User.find('eef1664e-f087-44c1-8bb3-003b88252d89')
ActiveRecord::RecordNotFound: Couldn't find User with
id=eef1664e-f087-44c1-8bb3-003b88252d89
```

Next, we're going to create a user object that we'll use to restore
the object from the database:
```
irb(main):001:0> user = User.new
irb(main):001:0> user.id = 'eef1664e-f087-44c1-8bb3-003b88252d89'
```

Using this User stub, we can extract the last revision into another
record and save it:
```
irb(main):001:0> last_user = user.revisions.last
=> #<User id: nil, npi: "1000000000", first_name: "Whoops-undo-this",
last_name: "McClure", creatorid: nil, lastupdateid: nil, createddate:
"2013-02-22 16:34:51", lastupdatedate: "2013-02-22 16:35:36",
createddate_as_number: 20130222163451, lastupdatedate_as_number:
20130222163451, enabled: true>
irb(main):001:0> last_user.save!
=> true
```

Other revisions can be viewed through #revisions:
```
irb(main):001:0> user.revisions
=> [#<User id: nil, npi: "1000000000", first_name: "Abdul", last_name:
"McClure", creatorid: nil, lastupdateid: nil, createddate: "2013-02-22
16:34:51", lastupdatedate: "2013-02-22 16:34:51", createddate_as_number:
nil, lastupdatedate_as_number: nil, enabled: true>, #<User id: nil, npi:
"1000000000", first_name: "Whoops-undo-this", last_name: "McClure",
creatorid: nil, lastupdateid: nil, createddate: "2013-02-22 16:34:51",
lastupdatedate: "2013-02-22 16:35:36", createddate_as_number: nil,
lastupdatedate_as_number: nil, enabled: true>, #<User id: nil, npi:
"1000000000", first_name: "Whoops-undo-this", last_name: "McClure",
creatorid: nil, lastupdateid: nil, createddate: "2013-02-22 16:34:51",
lastupdatedate: "2013-02-22 16:35:36", createddate_as_number:
20130222163451, lastupdatedate_as_number: 20130222163451, enabled:
true>]
```

You can use `revision_at(time)` to restore to any time:
```
older_user = user.revision_at(2.days.ago)
older_user.save!
```
