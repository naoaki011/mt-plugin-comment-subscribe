# Comment Subscribe, a plugin for Movable Type

Authors: Robert Synnott. [Now being maintained by Byrne Reese and others on GitHub](http://github.com/endevver/mt-plugin-comment-subscribe).  
License: [Artistic License 2.0](http://www.opensource.org/licenses/artistic-license-2.0.php)  
Site: <http://plugins.movabletype.org/comment-subscribe/>

## Overview

This plugin provides the ability for commenters on a blog to subscribe to notifications via email of any future comment posted to a blog post.

## Features

* Adds ability for commenters to subscribe to receive notification email for each comment left after the comment when they choose to subscribe.
* Unsubscribe link is provided in each notification email.
* Only users who supply an email address (whether commenting anonymously or through one of the login systems which provides an email address) will get notifications.
* Email is sent to the subscribing commenter, "from address" is the user leaving the new comment.
* A user won't get notified when they themselves make a comment.
* Customizable template for email notifications
* Customizable subject for email notifications
* Send emails via a background task to speed up comment process (requires run-periodic-tasks)

## Requirements

* MT 4.x or Melody 1.x

## Documentation

### Setup 

Add the following to the comment form (often this is thee "Comment Form" template in the "Template Modules" section):

    <div id="comment-form-subscribe">
        <label for="comment-subscribe"><input type="checkbox" id="comment-subscribe" name="subscribe" checked />
        Receive email notification of further comments.</label>
    </div>

*This code is typically inserted before or after the comment textarea.*

### Customizing the Email's Subject and From Fields

To customize the email address comment notifications will be sent from, as well as the subject of comment notifications, navigate to the plugin settings area for the Comment Subscribe plugin in the System Plugin listing screen. From there, follow the instructions below each of the plugins options.

### Customizing the Email Notification Template

To customize the text of the email notification template, navigate to the System's Template Listing screen. A template called "Comment Notification to Subscribers" will be listing among your "Email Templates." Edit that template.

The template supports a number of different variables that you can use inside the template to customize the text of the email. They are:

* entry_title
* entry_permalink
* entry_author
* entry_author_email
* entry_permalink
* comment_author
* comment_text
* unsub_link

Adding a variable to a template is done using the following syntax:

    <$mt:var name="entry_title"$>

*Please note: law requires that users be given the option to unsubscribe from future notifications. Please ensure that the `unsub_link` is always present in your template.*

## Installation

To install this plugin follow the instructions found here:

http://tinyurl.com/easy-plugin-install

## Desired Features Wish List

* add ability for email "from address" to optionally be the system email address rather than the email address of the commenter leaving a new comment.

## Support

This plugin is not an official release, and as such support for this plugin is not available.
