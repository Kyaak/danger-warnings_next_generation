# danger-warnings_next_generation

A description of danger-warnings_next_generation.

## Installation

    $ gem install danger-warnings_next_generation

## Example

### Warnings Next Generation Overview

|**Tool**|:beetle:|:x:|:white_check_mark:|
|:---|:---:|:---:|:---:|
|Android Lint Warnings|10|0|3|
|PMD Warnings|:star:|0|0|
|Detekt Warnings|10|5|5|
|Checkstyle|:star:|0|3|

### Java Warnings

|**Severity**|**File**|**Description**|
|---|---|---|
|NORMAL|ProductDetailPageFragment.kt:135|[Deprecation] 'getColor(Int): Int' is deprecated. Deprecated in Java|
|NORMAL|ImageGalleryFragment.kt:40|[] Type mismatch: inferred type is java.util.ArrayList<String!>? but kotlin.collections.ArrayList<String> /* = java.util.ArrayList<String> */ was expected|
|NORMAL|ImageGalleryFragment.kt:87|[Deprecation] 'getColor(Int): Int' is deprecated. Deprecated in Java|
|NORMAL|ImageGalleryFragment.kt:90|[Deprecation] 'getColor(Int): Int' is deprecated. Deprecated in Java|
|NORMAL|RequestQueue.java:15|[Rawtypes] found raw type: Request|
|NORMAL|RequestQueueImpl.java:25|[Rawtypes] found raw type: Request|
|NORMAL|RequestQueueImpl.java:27|[Unchecked] unchecked method invocation: method add in class RequestQueue is applied to given types|
|NORMAL|RequestQueueImpl.java:27|[Unchecked] unchecked conversion|

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
