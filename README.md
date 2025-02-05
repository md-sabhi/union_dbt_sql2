*This is a sample dbt Core project for Fivetran users– it can be cloned and modified to help you get up and running with Fivetran Transformations for dbt Core™.*

*While this repository can be connected into Fivetran as-is, we recommend that you install an IDE and dbt Core locally to develop your production models. More information on setting up your local environment can be found in the [dbt Labs documentation](https://docs.getdbt.com/quickstarts/manual-install?step=1).*

# Step 1: Use this example dbt project as a template
Click 'Use this template' and then 'create a new repository'.


# Step 2: Copy stored procedure and paste into my_stored_procedure.sql file (lines 7-8)
The my_stored_procedure.sql file is located in the /macros directory. It is recommended that you rename this file, as well as the name of the macro which is located in line 1. Each addditional stored procedure should get it's own file and macro name.

This macro example executes raw sql on the target using the [run_query](https://docs.getdbt.com/reference/dbt-jinja-functions/run_query) macro

# Step 3: Link this repository to Fivetran
Follow the setup guide in Fivetran which includes adding a deploy key.

# Step 4: Create a Job in Fivetran that executes your macros (which are now your stored procedures)
Create a new dbt core job and enter this command:
``` dbt run-operation my_stored_procedure ```

# Step 5: Run your job and add it to a schedule
Run your job to make sure it succeeds and then add it to a schedule option.