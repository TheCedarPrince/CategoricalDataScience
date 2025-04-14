using DrWatson
@quickactivate "CompositionalMLStudy"

using DataFrames

import DBInterface:
    connect,
    execute
import DrWatson:
  datadir
import DuckDB:
    DB
import IPUMS:
  load_ipums_extract,
  parse_ddi

const CONNECTION = connect(DB, "/home/thecedarprince/FOSS/dbt-synthea/synthea_1M_3YR.duckdb")
const DDI_FILE = "cps_00097.xml"
const DAT_FILE = "cps_00097.dat"
const IPUMS_DIR = datadir("exp_raw", "IPUMS")
const SCHEMA = "dbt_synthea_dev"
const DIALECT = :postgresql

catalog = reflect(
  CONNECTION;
  schema = SCHEMA,
  dialect = DIALECT
);

ddi = parse_ddi(joinpath(IPUMS_DIR, DDI_FILE));
ipums = load_ipums_extract(ddi, joinpath(IPUMS_DIR, DAT_FILE));

fun_sql = translate(    
    cohort_definition,    
    cohort_definition_id = cohort_definition_id
);

sql = render(catalog, fun_sql);

res = execute(conn,    
    """    
    INSERT INTO        
        dbt_synthea_dev.cohort    
    SELECT        
        *    
    FROM        
        ($sql) 
    AS 
        foo;    
    """
)

#=

1. Cut or finish ACSet-ifying OMOP CDM 
1. Test for adding parts
1. Create visualization with graph viz
2. ACSet-ify weather data
2. Test for adding parts
2. Create visualization with graph viz
3. ACSet-ify IPUMS CPS data
3. Test for adding parts
3. Create visualization with graph viz
4. Put all ACSet information into same ACSet presentation
4. Test for adding parts
5. Create conjunctive query similar to this: https://github.com/slwu89/CompositionalMLStudy/blob/82a072ad6db3ab003f125811c9f2620505c1d378/notebooks/omopcdm_uwd_exploration.jl#L135
6. Generate patient cohort for weather related disease
7. Write query to get patient cohort (stroke)
8. Write query to get all patients
9. Make dataset using queries
10. Create binary encoding of condition/not condition
11. Create final visualization with graph viz

=#
