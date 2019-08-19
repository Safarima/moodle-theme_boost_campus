@theme @theme_boost_campus
Feature: Configuring the theme_boost_campus plugin
  In order to use the features
  As admin
  I need to be able to configure the theme Boost Campus plugin

  ### Notice: The @javascript tag is not working somehow and this error message will occur:
  ### Javascript code and/or AJAX requests are not ready after xxx seconds. There is a Javascript error or the code is extremely slow.
  ### If you are using a slow machine, consider setting $CFG->behat_increasetimeout. (Exception)
  ### $CFG->behat_increasetimeout = 100 did not help...
  ### That's why only scenarios that do not need Javascript can be tested currently.

  Background:
    Given the following "users" exist:
      | username |
      | student1 |
      | teacher1 |
    And the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |
    And the following config values are set as admin:
      | theme | boost_campus |

  ### Tab "Gerenal Settings" ###
  # Is either derivated from Boost, needs Javascript or is not testable with Behat.

  ### Tab "Advanced Settings" ###

  # This is not testable with Behat #
  Scenario: Add "Raw initial SCSS"
  Scenario: Add "Raw SCSS"
  Scenario: "Catch keyboard commands"

  Scenario: Set "Position of "Add a block" widget" to "At the bottom of the default block region"
    Given the following config values are set as admin:
      | config            | value               | plugin             |
      | addablockposition | positionblockregion | theme_boost_campus |
    When I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    Then I should see "Add a block" in the "#block-region-side-pre" "css_element"

  Scenario: Set "Position of "Add a block" widget" to "At the bottom of the nav drawer"
    Given the following config values are set as admin:
      | config            | value             | plugin             |
      | addablockposition | positionnavdrawer | theme_boost_campus |
    When I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    Then I should see "Add a block" in the "#nav-drawer" "css_element"

  ### Tab "Course Layout Settings" ###

  Scenario: Enable "Section 0: Title"
    Given the following config values are set as admin:
      | config        | value   | plugin             |
      | section0title | yes     | theme_boost_campus |
    When I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    Then I should see "General" in the "li#section-0" "css_element"
    When I edit the section "0" and I fill the form with:
      | Custom                     | 1                           |
      | New value for Section name | This is the general section |
    Then I should see "This is the general section"

  Scenario: Enable "Course edit button"
    Given the following config values are set as admin:
      | config           | value | plugin             |
      | courseeditbutton | 1     | theme_boost_campus |
    When I log in as "teacher1"
    And I am on "Course 1" course homepage
    Then I should see "Turn editing on" in the ".singlebutton" "css_element"
    When I click on "Turn editing on" "button"
    Then I should see "Turn editing off" in the ".singlebutton" "css_element"
    And I should see "Add an activity or resource"

  Scenario: Enable "Position of switch role information"
    Given the following config values are set as admin:
      | config                   | value | plugin             |
      | showswitchedroleincourse | yes   | theme_boost_campus |
    When I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I click on "Switch role to..." "link"
    And I click on "Student" "button"
    Then I should see "You are viewing this course currently with the role:"
    And I should not see "Turn editing on"
    When I click on "Return to my normal role" "link"
    Then I should see "Turn editing on"

  Scenario: Enable "Show hint in hidden courses"
    Given the following config values are set as admin:
      | config               | value | plugin             |
      | showhintcoursehidden | yes   | theme_boost_campus |
    When I log in as "teacher1"
    And I am on "Course 1" course homepage
    When I navigate to "Edit settings" in current page administration
    And I set the following fields to these values:
      | Course visibility | Hide |
    And I click on "Save and display" "button"
    Then I should see "This course is currently hidden. Only enrolled teachers can access this course when hidden."

  Scenario: Enable "Show hint for guest access"
    Given the following config values are set as admin:
      | config                    | value | plugin             |
      | showhintcourseguestaccess | yes   | theme_boost_campus |
    And the following "users" exist:
      | username |
      | student2 |
    When I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I navigate to "Users > Enrolment methods" in current page administration
    And I click on "Edit" "link" in the "Guest access" "table_row"
    And I set the following fields to these values:
      | Allow guest access | Yes |
    And I press "Save changes"
    And I follow "Log out" in the user menu
    When I log in as "student2"
    And I am on "Course 1" course homepage
    Then I should see "You are currently viewing this course as Guest."
    And I follow "Log out" in the user menu
    And I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I navigate to "Users > Enrolment methods" in current page administration
    And I click on "Enable" "link" in the "Self enrolment (Student)" "table_row"
    And I follow "Log out" in the user menu
    When I log in as "student2"
    And I am on "Course 1" course homepage
    Then I should see "To have full access to the course, you can self enrol into this course."
    And I click on "self enrol into this course" "link" in the ".course-guestaccess-infobox" "css_element"
    And I click on "Enrol me" "button"
    Then I should not see "You are currently viewing this course as Guest."

#  @javascript
#  Scenario: Enable "In course settings menu"
#  # Dependent on setting above
#  Scenario: Set "Switch role to..." location(s)

  ### Tab "Additional Layout Settings" ###

#  @javascript
#  Scenario: Add "Image area items"
#  # Dependent on setting above
#  Scenario: Add "Image area item links"
#  Scenario: Set "Image area items maximal height"

  Scenario: Use Footnote setting
    Given the following config values are set as admin:
      | config   | value                                           | plugin             |
      | footnote | <a href="/login/logout.php">Logout Footnote</a> | theme_boost_campus |
    When I log in as "teacher1"
    Then I should see "Logout Footnote"
    And I click on "Logout Footnote" "link"
    Then I should see "Do you really want to log out?"

  Scenario: Enable "Dashboard menu item on top"
    Given the following config values are set as admin:
      | config               | value | plugin             |
      | defaulthomepageontop | yes   | theme_boost_campus |
    When I log in as "teacher1"
    Then "Dashboard" "link" should appear before "Site home" "link"
    When I am on "Course 1" course homepage
    Then "Dashboard" "link" should appear before "Site home" "link"

   # This is not testable with Behat #
#  Scenario: Enable "Nav drawer full width on small screens"

  ### Tab "Design Settings" ###

#  @javascript
#  Scenario: Use Login page background images
#  Scenario: Display text for login background images
#  Scenario: Add "Font files"
#  Scenario: Enable "Show help texts in a modal dialogue"
#  Scenario: Add additional resources

   # This is not testable with Behat #
#  Scenario: Enable "Login form"
#  Scenario: Enable "Block icon"
#  Scenario: Change "Block column width on Dashboard"
#  Scenario: Change "Block column width on all other pages"
#  Scenario: Change breakpoint

  Scenario: Enable "Dark navbar"
    Given the following config values are set as admin:
      | config     | value | plugin             |
      | darknavbar | yes   | theme_boost_campus |
    When I log in as "teacher1"
    Then "nav.bg-dark" "css_element" should exist
