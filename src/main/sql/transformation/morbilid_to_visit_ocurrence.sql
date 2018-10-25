/*
Visit ocurrence table
*/
INSERT INTO cdm5.visit_occurrence (visit_occurrence_id,
                                   person_id,
                                   visit_concept_id,
                                   visit_type_concept_id,
                                   visit_source_concept_id,
                                   visit_source_value,
                                   visit_start_datetime,
                                   visit_end_datetime,
                                   admitted_from_concept_id,
                                   discharge_to_concept_id)


SELECT intermediate_table_visit_ocurrence.visit_ocurrence_id AS visit_ocurrence_id,
       person.person_id                                      AS person_id,

    -- Outpatient visit
       9202                                                  AS visit_concept_id,

    -- Visit derived from EHR encounter record
       44818518                                              AS visit_type_concept_id,
       0                                                     AS visit_source_concept_id,
       'tb_morbilid'                                         AS visit_source_value,

    -- Assumption: 1 day visits
    --TODO visits last 0 minutes? (timestamp format)
       (cast(tb_morbilid.fecha_inicio as text) || ' 00:00:00'):: timestamp             AS visit_start_datetime,
       (cast(tb_morbilid.fecha_inicio as text) || ' 00:00:00'):: timestamp             AS visit_end_datetime,

      --TODO check this assumption:
      0                                                     AS admitted_from_concept_id,
      0                                                     AS discharge_to_concept_id

FROM public.tb_morbilid
       LEFT JOIN source_intermediate.intermediate_table_visit_ocurrence
         ON (tb_morbilid.numsipcod = intermediate_table_visit_ocurrence.numsipcod
               AND
             tb_morbilid.fecha_inicio = intermediate_table_visit_ocurrence.date)
         -- We only want visits from "valid" persons from person table
       RIGHT JOIN cdm5.person ON intermediate_table_visit_ocurrence.numsipcod = person.person_source_value;