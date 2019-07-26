The Boxing Kata
=================

Everyone who has dental insurance and receive perks in the form of electric toothbrushes, replacement brush heads, and paste kits (toothpaste and floss). These perks are provided at the start of an insurance contract and then semi-frequently throughout the life of the contract. Each family member gets to choose a toothbrush color at enrollment, and will receive replacement toothbrush heads of the same color.

This kata involves building the brains of a boxing system which will determine how the perks are boxed up and shipped. Given a family's brush color preferences, the system will generate a description of how the boxes should be filled. A shipping manager must be able to load data for a family, create starter and refill boxes, and perform other operations in real-time. The focus of this kata should be building a library for the system rather than a UI.

Instructions
------------
Please read through the user stories below and implement the functionality to complete them according to their requirements. The design is entirely up to you as long as the solution can be run via the entry point in the bin directory (see below).

We ask that you please add tests and commit your work to git frequently as you go.

Setup
-----

```
bundle install
bin/rspec
```

An entry point has been provided:

```
ruby ./bin/boxing-kata <spec/fixtures/family_preferences.csv
```

--------------------

Please include a `.ruby-version` file with your submission. There are differences between versions that can be significant to your application's runtime versus your reviewer's installed ruby version.

Once you're happy with your submission, you can send it back in one of two formats, as a git bundle or as a zip file.

To create the git bundle simply execute:

```bash
cd boxing-kata
git bundle create boxing-kata.bundle <YOUR BRANCH NAME HERE>
```

This will create a `.bundle` file which contains the entire git repository in binary form, so you can easily send it as an attachment.  Alternately, you could send the project as a zip file.

Example Input File
------------------
The input file is a CSV file which contains the following fields:

```
id,name,brush_color,primary_insured_id,contract_effective_date
2,Anakin,blue,,2018-01-01
3,Padme,pink,2,,
4,Luke,blue,2,,
5,Leia,green,2,,
6,Ben,green,2,,
```

Currently, we only support one family per configuration file.

User Stories
--------------

**Importing family preferences**

_As a Shipping Manager_<br>
_In order to ship perks_<br>
_I want to view family member brush preferences_<br>

To begin the boxing process the shipping manager must import family data.  When the system receives the input file, then the brush color counts will be displayed in the format below.

```
BRUSH PREFERENCES
blue: 2
green: 2
pink: 1
```
**Starter boxes**

_As a Shipping Manager_<br>
_In order to ship perks_<br>
_I want to fill starter boxes_<br>

Now that member data has been imported, the shipping manager can begin filling boxes. Each family member will receive one brush and one replacement head. Both the brush and the replacement head must be in the family member's preferred color. A starter box can contain a maximum of 2 brushes and 2 replacement heads in any combination of colors.

When the shipping manager presses the starter boxes button, then a number of boxes are output.  Using the brush preferences example above, box output will be generated in the following format:

```
STARTER BOX
2 blue brushes
2 blue replacement heads

STARTER BOX
2 green brushes
2 green replacement heads

STARTER BOX
1 pink brush
1 pink replacement head
```

If no family preferences have been entered then the message `NO STARTER BOXES GENERATED` should be displayed.

**Refills**

_As a Shipping Manager_<br>
_In order to ship perks_<br>
_I want to fill refill boxes_<br>

A family should receive refill boxes with a replacement brush head in each member's preferred color. A refill box can contain a maximum of 4 replacement heads. When the shipping manager presses the refill boxes button, then a number of refill boxes are output.  Using the brush preferences example above, box output will be generated in the following format:

```
REFILL BOX
2 blue replacement heads
2 green replacement heads

REFILL BOX
1 pink replacement head
```

If no starter boxes have been generated, then the message `PLEASE GENERATE STARTER BOXES FIRST` should be displayed.

**Scheduling**

_As a Shipping Manager_<br>
_In order to ship perks_<br>
_I want to schedule boxes for shipping_<br>

Members should receive perks throughout the length of their contract (1 year).  The shipping date is based on the contract effective date of the primary insured family member.  Starter boxes should be scheduled on the contract effective date.  Refills are scheduled every 90 days after that for the remainder of the year. When boxes are generated then each box should have a line appended with its scheduled ship date(s).

Example for a starter box:
```
STARTER BOX
2 green brushes
2 green replacement head
Schedule: 2018-01-01
```

Example for a refill box:
```
REFILL BOX
1 pink replacement head
Schedule: 2018-04-01, 2018-06-30, 2018-09-28, 2018-12-27
```

**Mail Class**

_As a shipping manager_<br>
_In order to save money on shipping_<br>
_I want to determine mail class_<br>

In order to manage shipping costs and to deliver perks quickly we want to determine the mail class of boxes. Mail class is based on the weight of the box. Boxes that weigh 16oz or more have a class of "priority".  Boxes that weigh less than 16oz have a mail class of "first". Weight is calculated as such: 1 brush weighs 9oz, and 1 replacement head weighs 1oz. When boxes are generated, then each box should have a line appended with its mail class.

Example for a starter box:
```
STARTER BOX
2 green brushes
2 green replacement head
Schedule: 2018-01-01
Mail class: priority
```

Example for a refill box:
```
REFILL BOX
1 pink replacement head
Schedule: 2018-04-01, 2018-06-30, 2018-09-28, 2018-12-27
Mail class: first
```

**Paste Kits**

_As a shipping manager_<br>
_In order to ship paste kits_<br>
_I want to add paste kits to the boxes_<br>

For each brush or replacement head that is shipped a paste kit is also shipped which contains toothpaste and floss. A paste kit weighs 7.6 oz which will impact on the mail class choice.

Example for a starter box:
```
STARTER BOX
1 pink brushes
1 pink replacement head
1 paste kit
Schedule: 2018-01-01
Mail class: priority
```

Example for a refill box:
```
REFILL BOX
1 pink replacement head
1 paste kit
Schedule: 2018-04-01, 2018-06-30, 2018-09-28, 2018-12-27
Mail class: first
```
