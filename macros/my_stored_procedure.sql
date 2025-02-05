{% macro my_stored_procedure() %}

{% if execute %}

    {% set call_stored_procedure %}

        use schema stored_procedure_outputs;
        call lowery_simple_sproc();

    {% endset %}
    {{ log('About to execute this statement ' ~ call_stored_procedure, info=True) }}
    {{ log('Calling procedure from dbt..', info=True) }}
    {% set query_results = run_query(call_stored_procedure) %}

    {% if query_results|length > 0 %}
        {{ log('Query ran successfully, here are the results: ', info=True) }}
        {% do query_results.print_json() %}
    {% else %}
        {{ log('There was an issue with this query: ', info=True) }}
        {% do query_results.print_json() %}
    {% endif %}

{% endif %}

{% endmacro %}