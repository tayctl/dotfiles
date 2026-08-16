--vim.g.dbs = {
--   { name = "university", url = "mariadb://root:admin@localhost:3306/UniversityDB" },
--  { name = "company",    url = "mariadb://root:admin@localhost:3306/CompanyDatabase" },
--  { name = "company",    url = "mariadb://root:admin@localhost:3306/CompanyDatabase" },
--}

vim.g.db = "mariadb://root:admin@localhost:3306/Recipes"


vim.lsp.config('sqls', {
  settings = {
    sqls = {
      connections = {
--        {
--          driver = 'mysql',
--          dataSourceName = 'root:admin@tcp(localhost:3306)/UniversityDB',
--        },
        {
          driver = 'mysql',
          dataSourceName = 'root:admin@tcp(localhost:3306)/Recipes',
        },
--        {
--          driver = 'mysql',
--          dataSourceName = 'root:admin@tcp(localhost:3306)/CompanyDatabase',
--        },
      },
    },
  },
})
vim.lsp.enable('sqls')
