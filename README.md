# Sequra challenge

This README acts as a decription for my submission for the Sequra code challange. It describes my plan and thought process, serves as reference for the code and contains the installation and running instructions.

## The plan

The challenge requires correctness over completeness, so I will develop in a way that aims at always having something functional that can be used with confidence (i.e., readable and maintainable, performant, logged, tested and documented), before adding a new feature or improvement. As such, the development will be in iterations.

Once the time limit of 3 hours is reached, I will stop the development and upload the code and documentation, which will already be up-to-date.

### Iteration 1: Project setup

The first step is to set up the project and dependencies, so that the project can be run. I will use some tools that improve maintainability and facilitate collaboration.

The framework that is going to be used is Ruby on Rails 7 with Ruby 3.2. It offers support for many of the task requirements, including data modeling and persistence (Sqlite3 for simplicity), the endpoint, helpers for operations, etc. It also has good tooling and test support (RSpec in this case).

### Iteration 2: Existing models

The second step will be to set up the existing models Merchants, Shoppers and Orders. I will also seed them from the JSON files. Shoppers are only required to check for foreign keys, but will not be otherwise used. Merchants are similar, but they can be used to validate if a merchant ID in an endpoint is valid. Orders will be the base for the disbursement calculation.

These models themselves appear to be somewhat out of scope of the task, but they will still be tested for data consistency, as this is production ready code.

Negative order values are not specified. I will assume they are not possible and an error should be raised if trying to create one.

### Iteration 3: Weekly order disbursements

The next phase is the implementation of the disbursement model for orders. There will be one disbursement per order. Disbursements are limited to two decimals, since we are dealing with monetary data.

Each disbursement will also belong to a merchant and a week. This field combination will be indexed for faster queries (also for the week-only query).

There are several ways to represent a week, e.g. year + calendar week, start of week or end of week. The task itself does not give any hints, so I will use start of week, as that is what is most natural to me and easy to work with, but in production, this should be user or requirements driven.

### Iteration 4: Disbursement calculation

The first iteration of the calculation will hard-code the rules in a method. This is not the most elegant solution, but allows to quickly have an MVP of sorts, that is safe to operate and can be replaced easily later on. This method can be a class method of the Disbursement class.

There will also be class method to kick-start the weekly calculation. It takes the start of the week as a parameter. It will then query all of the orders that have been completed in that week and calculate and persist a disbursement for each order.

The reason for it being a class method is so that it can be run from anywhere with just a parameter and not much overhead.

### Iteration 5: Disbursement endpoint

The next step is an endpoint to fetch the disbursement of a week. It has an optional merchant id parameter. Calls will have these formats: `/disbursements/show/2023-01-16` or `/disbursements/show/2023-01-16?merchant=123`.

It returns a JSON formatted list of disbursements. If the merchant is given, it will return only the disbursements of that week of that merchant, otherwise all of the disbursements of that week.

The endpoint will query the persisted disbursements from iteration 4. If there are no disbursements, an empty list is returned.

If the merchant ID is invalid (i.e., does not exist), an error is raised in form of a 404 with an object and an `error` key describing it. This is more user and developer-friendly than jsut returning an empty list, but can provide security issues as system information is revealed. But in a real system, merchants can probably be queried directly, so there would not be a disadvantage.

### Iteration 6: Disbursement summaries

Single-order disbursements are good for traceability and allow to calculate the summaries, but they can be slow, as potentially many records need to fetched and processed. The summary will be a new model which holds the sum of all order summaries, so only one record per merchant per week needs to be fetched. It too will have an index on week and merchant ID for quick queries.

Calculation of both models requires the same data, so a single pass can be used for both. We move the calculation to a new class, CalculationManager to make it more isolated.

There will also be new endpoint, `/disbursement-summaries` which works in the same way as `/disbursements`. It is not included into `/disbursements` directly to avoid either having to fetch both (which would negate the speed advantage) or have to deal with many different query parameters (like ?summary=true).

### Iteration 7: Disbursement rules

The first version uses hard-coded rules for the percentages, which is good for a fast release, but not practical in the long run. A new model, which holds the rules of which percentage to apply in which price range is created. The rules can then be easily modified by non-technical people by creating new records in a database and a history can be created if the rules have start and end dates.

The calculation manager will load these rules into a cache at calculation start for quick access and the method to calculate the disbursement for an order can just look up the percentage in this cache.
