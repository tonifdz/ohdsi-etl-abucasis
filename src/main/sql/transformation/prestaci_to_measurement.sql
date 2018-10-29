/*
Clinical measurements
*/
INSERT INTO cdm5.measurement
(
  person_id,
  value_as_number,
  measurement_concept_id,
  measurement_source_concept_id,
  measurement_source_value,
  measurement_date,
  measurement_datetime,
  unit_concept_id,
  unit_source_value,
  measurement_type_concept_id
)
  SELECT
    person.person_id                    AS person_id,
    valor_registrado                    AS value_as_number,
    coalesce(pres.target_concept_id, 0) AS measurement_concept_id,
    coalesce(pres.source_concept_id, 0) AS measurement_source_concept_id,
    cod_prestacion                      AS measurement_source_value,
    fecha_registro                      AS measurement_date,
    fecha_registro :: TIMESTAMP         AS measurement_datetime,
    coalesce(unit.target_concept_id, 0) AS unit_concept_id,
    coalesce(unit.source_concept_id)    AS unit_source_value,
    44818702                            AS measurement_type_concept_id
  FROM public.tb_prestaci
    --only patients also present in person table to be included
    JOIN cdm5.person ON numsipcod = person.person_source_value
    --TODO: add abucasis_prestacion concepts to source_to_concept_map table
    LEFT JOIN cdm5.source_to_concept_map pres
      ON cod_prestacion = pres.source_code AND pres.source_vocabulary_id = 'ABUCASIS_TIP_PREST'
    LEFT JOIN cdm5.source_to_concept_map unit
      ON cod_ud_medida = unit.source_code AND unit.source_vocabulary_id = 'ABUCASIS_UD_MEDIDAS'
  WHERE tb_prestaci.cod_prestacion NOT LIKE '-1'
;