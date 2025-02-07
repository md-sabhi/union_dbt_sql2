{% macro union_tables() %}

{% set schema_pattern = '%fnb_src_%_bhmark%' %}
{% set table_pattern = '%aggregatedbhmark%' %}
{% set golden_schema_name = 'golden_schema' %}
{% set relation = dbt_utils.get_relations_by_pattern(schema_pattern, table_pattern) %}

{% set all_tables = [] %}
{% set all_columns = [] %}

{% for source_table in relation -%}
    {{ log('looking through this table ' ~ source_table|lower, info=True) }}
    {% set parent_table_lower = source_table.table|lower%}
    {% if parent_table_lower not in all_tables %}
        {{ log('adding this table to master list -> ' ~ parent_table_lower, info=True) }}
        {{ all_tables.append(parent_table_lower)}}
    {% else %}
        {{ log('we already added this table -> ' ~ parent_table_lower, info=True) }}
    {% endif %}
{% endfor %}

{{ log('the master list of tables are ' ~ all_tables, info=True) }}

{{ log('creating the golden_schema... ', info=True) }}
{% set create_schema_query %}
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = '{{ golden_schema_name }}') EXEC('CREATE SCHEMA "{{ golden_schema_name }}"');
{% endset %}

{% set create_schema_query_results = run_query(create_schema_query) %}

{{ log('golden_schema created successfully ' ~ create_schema_query_results, info=True) }}

{{ log('creating the golden tables ', info=True) }}

{% for golden_table in all_tables -%}
    {% set table_relation = dbt_utils.get_relations_by_pattern(schema_pattern, golden_table) %}
    {% set table_query = dbt_utils.union_relations(table_relation) %}
   
    {% set table_create_query %}
        SELECT x.* INTO  {{target.database}}.{{golden_schema_name}}.{{golden_table}}   from ( {{table_query}} ) as x
    {% endset %}

    {% set table_results = run_query(table_create_query) %}
     {{print(table_results)}}

    {% if table_results|length > 0 %}
        {{ log('Created golden table ' ~ golden_table, info=True) }}
    {% else %}
        {{ log('No clue man ' ~ golden_table, info=True) }}
    {% endif %}
{% endfor %}

{% endmacro %}
