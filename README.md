<h1 align="center">danger-warnings_next_generation</h1>

<div align="center">
  <!-- Sonar Cloud -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings_next_generation">
    <img src="https://sonarcloud.io/images/project_badges/sonarcloud-white.svg"
      alt="Sonar Cloud" />
  </a>
</div>

</br>

<div align="center">
  <!-- Version -->
  <a href="https://badge.fury.io/rb/danger-warnings_next_generation">
    <img src="https://badge.fury.io/rb/danger-warnings_next_generation.svg" alt="Version" />
  </a>
  <!-- Downloads -->
  <a href="https://badge.fury.io/rb/danger-warnings_next_generation">
    <img src="https://img.shields.io/gem/dt/danger-warnings_next_generation.svg" alt="Downloads" />
  </a>
</div>

<div align="center">
  <!-- Build Status -->
  <a href="https://travis-ci.org/Kyaak/danger-warnings_next_generation">
    <img src="https://img.shields.io/travis/choojs/choo/develop.svg"
      alt="Build Status" />
  </a>
  <!-- Coverage -->
    <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings_next_generation">
      <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings_next_generation&metric=coverage"
        alt="Coverage" />
    </a>
</div>

<div align="center">
  <!-- Reliability Rating -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings_next_generation">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings_next_generation&metric=reliability_rating"
      alt="Reliability Rating" />
  </a>
  <!-- Security Rating -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings_next_generation">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings_next_generation&metric=security_rating"
      alt="Security Rating" />
  </a>
  <!-- Maintainabiltiy -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings_next_generation">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings_next_generation&metric=sqale_rating"
      alt="Maintainabiltiy" />
  </a>
</div>

<div align="center">
  <!-- Code Smells -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings_next_generation">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings_next_generation&metric=code_smells"
      alt="Code Smells" />
  </a>
  <!-- Bugs -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings_next_generation">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings_next_generation&metric=bugs"
      alt="Bugs" />
  </a>
  <!-- Vulnerabilities -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings_next_generation">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings_next_generation&metric=vulnerabilities"
      alt="Vulnerabilities" />
  </a>
  <!-- Technical Dept -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings_next_generation">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings_next_generation&metric=sqale_index"
      alt="Technical Dept" />
  </a>
</div>
</br>

This [danger](https://github.com/danger/danger) plugin generates overview and detail reports for code analysis results. :detective: <br>

This plugin is inspired and works only with the jenkins [warnings-ng-plugin](https://github.com/jenkinsci/warnings-ng-plugin) :bowing_man:


    To avoid an overload of issues in the pull request, only issues for changed files are listed.
    The overview report will always contain the number of total, new and fixed issues. 


## How it looks like

### Warnings Next Generation Overview

|**Tool**|:beetle:|:x:|:white_check_mark:|
|:---|:---:|:---:|:---:|
|Android Lint Warnings|10|0|3|
|PMD Warnings|:star:|0|0|
|Detekt Warnings|10|5|5|
|Checkstyle Warnings|:star:|0|3|

### Java Warnings

|**Severity**|**File**|**Description**|
|---|---|---|
|NORMAL|ProductDetailPageFragment.kt:135|[Deprecation] 'getColor(Int): Int' is deprecated. Deprecated in Java|
|NORMAL|ImageGalleryFragment.kt:40|Type mismatch: inferred type is java.util.ArrayList<String!>? but kotlin.collections.ArrayList<String> /* = java.util.ArrayList<String> */ was expected|
|NORMAL|MyUtil.java:5|[Design - HideUtilityClassConstructorCheck] 'getColor(Int): Int' is deprecated. Deprecated in Java|


### As inline
```text
NORMAL
[Correctness - GradleDependency]
Obsolete Gradle Dependency A newer version of com.android.support:design than 27.1.1 is available: 28.0.0 This detector looks for usages of libraries where the version you are using is not the current stable release. Using older versions is fine, and there are cases where you deliberately want to stick with an older version. However, you may simply not be aware that a more recent version is available, and that is what this lint check helps find.
```

## Installation

    $ gem install danger-warnings_next_generation

## Usage

<blockquote>Show overview and tool reports for all found analytic tools.
<pre>
warnings_next_generation.report
</pre>
</blockquote>   

<blockquote>Show overview and tool reports for selected analytic tools
<pre>
warnings_next_generation.report(
    # must match tool id
    include: ['android-lint', 'java', 'pmd']
)
</pre>
</blockquote>   

<blockquote>Show overview and tool reports with inline comments
<pre>
warnings_next_generation.report(
    inline: true,
    # inline comments require a baseline
    # file: "/var/lib/jenkins/workspace/projectname/repository/app/src/main/java/com/projectname/b2bshop/fragment/gallery/ImageGalleryFragment.kt
    # baseline: "/var/lib/jenkins/workspace/projectname/repository/
    baseline: '/path/to/workspace/repository/root'
)
</pre>
</blockquote>   

<blockquote>Only overview report
<pre>
warnings_next_generation.overview_report(
    include: ['java']
)
</pre>
</blockquote>   

<blockquote>Only tools report
<pre>
warnings_next_generation.tools_report(
    include: ['java', 'pmd']
    inline: true,
    baseline: '/path/to/workspace/repository/root'
)
</pre>
</blockquote>   

## Authentication

If you run a jenkins server with required authentication you can pass them to `danger-warnings_next_generation`.
Create an API token with your CI user and do not pass normal password credentials.

<blockquote>Run all with authentication
<pre>
warnings_next_generation.report(
    auth_user: "jenkins",
    auth_token: "MY_TOKEN"
)
</pre>
</blockquote>   

<blockquote>Run overview with authentication
<pre>
warnings_next_generation.overview_report(
    auth_user: "jenkins",
    auth_token: "MY_TOKEN"
)
</pre>
</blockquote>   
