SELECT
   housing_price_index.index_sa,
   regional_income.DataValue,
   regional_income.GeoName,
   regional_income.TimePeriod
FROM
   housing_price_index
       JOIN
   states ON states.Abbreviation = housing_price_index.state
       JOIN
   regional_income ON regional_income.GeoName = states.Name
        WHERE
   housing_price_index.TimePeriod = regional_income.TimePeriod;
