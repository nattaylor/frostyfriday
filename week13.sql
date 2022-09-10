select product, stock_amount, date_of_check,
  CASE
        WHEN stock_amount IS NULL THEN
            CASE
                WHEN LAG(stock_amount, 1) OVER (partition by product order by date_of_check asc) IS NOT NULL
                  THEN LAG(stock_amount, 1) OVER (partition by product order by date_of_check asc)
                WHEN LAG(stock_amount, 2) OVER (partition by product order by date_of_check asc) IS NOT NULL
                  THEN LAG(stock_amount, 2) OVER (partition by product order by date_of_check asc)
                WHEN LAG(stock_amount, 3) OVER (partition by product order by date_of_check asc) IS NOT NULL
                  THEN LAG(stock_amount, 3) OVER (partition by product order by date_of_check asc)
                WHEN LAG(stock_amount, 4) OVER (partition by product order by date_of_check asc) IS NOT NULL
                  THEN LAG(stock_amount, 4) OVER (partition by product order by date_of_check asc)
                END
        ELSE stock_amount
    END stock_amount_filled_out,
    coalesce(stock_amount, LAG(stock_amount, 1) ignore nulls OVER (partition by product order by date_of_check asc)) AS stock_amount_filled_out2,
    last_value(stock_amount ignore nulls) over (partition by product order by date_of_check rows between unbounded preceding and current row) AS stock_amount_filled_out3 
 from (values 
          ('Superhero capes',1,'2022-01-01'),
          ('Superhero capes',2,'2022-01-02'),
          ('Superhero capes',NULL,'2022-02-01'),
          ('Superhero capes',NULL,'2022-03-01'),
          ('Superhero masks',5,'2022-01-01'),
          ('Superhero masks',NULL,'2022-02-13'),
          ('Superhero pants',6,'2022-01-01'),
          ('Superhero pants',NULL,'2022-01-01'),
          ('Superhero pants',3,'2022-04-01'),
          ('Superhero pants',2,'2022-07-01'),
          ('Superhero pants',NULL,'2022-01-01'),
          ('Superhero pants',3,'2022-05-01'),
          ('Superhero pants',NULL,'2022-10-01'),
          ('Superhero masks',10,'2022-11-01'),
          ('Superhero masks',NULL,'2022-02-14'),
          ('Superhero masks',NULL,'2022-02-15'),
          ('Superhero masks',NULL,'2022-02-13')
      ) as testing_data(product, stock_amount,date_of_check) order by product,date_of_check
