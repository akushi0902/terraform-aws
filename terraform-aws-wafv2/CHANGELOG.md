# Changelog

All notable changes to this project will be documented in this file.

## [2.1.0](https://github.com/terraform-aws-modules/terraform-aws-wafv2/compare/v2.0.0...v2.1.0) (2026-05-14)

### Features

* Add region, typed redacted_fields, and validations to logging configuration ([#8](https://github.com/terraform-aws-modules/terraform-aws-wafv2/issues/8)) ([3d961f3](https://github.com/terraform-aws-modules/terraform-aws-wafv2/commit/3d961f39e4ad376962a5e3d5b3e2f3f59f332752))

## [2.0.0](https://github.com/terraform-aws-modules/terraform-aws-wafv2/compare/v1.3.0...v2.0.0) (2026-05-07)

### ⚠ BREAKING CHANGES

* Full WAFv2 parity — add rule-group, web-acl-rule, web-acl-rule-group-association, api-key submodules (#6)

### Features

* Full WAFv2 parity — add rule-group, web-acl-rule, web-acl-rule-group-association, api-key submodules ([#6](https://github.com/terraform-aws-modules/terraform-aws-wafv2/issues/6)) ([1d2444e](https://github.com/terraform-aws-modules/terraform-aws-wafv2/commit/1d2444e9036a2403c1cd27a8bc8fd1d02cf1065a))

## [1.3.0](https://github.com/terraform-aws-modules/terraform-aws-wafv2/compare/v1.2.0...v1.3.0) (2026-05-07)

### Features

* Support AND and OR statement in scope_down_statement ([#5](https://github.com/terraform-aws-modules/terraform-aws-wafv2/issues/5)) ([e6c8a40](https://github.com/terraform-aws-modules/terraform-aws-wafv2/commit/e6c8a401d30c67050591757a45862c0755964ab3))

## [1.2.0](https://github.com/terraform-aws-modules/terraform-aws-wafv2/compare/v1.1.1...v1.2.0) (2026-05-06)

### Features

* Support nested OR in AND statement and nested AND in OR statement ([#4](https://github.com/terraform-aws-modules/terraform-aws-wafv2/issues/4)) ([11b3fbc](https://github.com/terraform-aws-modules/terraform-aws-wafv2/commit/11b3fbc8cf5de093772a98eb47d16df3b6b627ab))

## [1.1.1](https://github.com/terraform-aws-modules/terraform-aws-wafv2/compare/v1.1.0...v1.1.1) (2026-05-06)

### Bug Fixes

* Add regex_match_statement support in nested not in AND and OR ([#3](https://github.com/terraform-aws-modules/terraform-aws-wafv2/issues/3)) ([4a134d0](https://github.com/terraform-aws-modules/terraform-aws-wafv2/commit/4a134d041123445288c5a3e36360b7c3e515d421))

## [1.1.0](https://github.com/terraform-aws-modules/terraform-aws-wafv2/compare/v1.0.0...v1.1.0) (2026-04-12)

### Features

* Added scope-down statement types ([#2](https://github.com/terraform-aws-modules/terraform-aws-wafv2/issues/2)) ([5f5b4eb](https://github.com/terraform-aws-modules/terraform-aws-wafv2/commit/5f5b4eb8160d899f1e4caa3ecf0a216923cc21ec))

## 1.0.0 (2026-04-06)

### Features

* Added WAFv2 module ([cc0c1a9](https://github.com/terraform-aws-modules/terraform-aws-wafv2/commit/cc0c1a95ad40256daac0902b2932c3d72ad2c70d))
