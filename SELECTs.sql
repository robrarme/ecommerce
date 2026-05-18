USE Ecommerce;

-- Quantos pedidos foram realizados por cada cliente?
SELECT CONCAT(FirstName,' ', MiddleNameInits,' ', LastName) as 'Nome Completo',COUNT(c.idOrder) as 'No. Pedidos', ROUND(AVG(FreightValue),2) as 'Média Frete por Pedido',
    SUM(Quantity) as 'Quantidade de Itens'
FROM Clients a, Payments b, Orders c, ProductOrders d, Products e
WHERE a.idClient = b.idClient AND b.idOrder = c.idOrder AND
	c.idOrder = d.idOrder AND d.idProduct = e.idProduct
GROUP BY a.idClient
ORDER BY 2 DESC;

-- Algum vendedor também é fornecedor?
SELECT * 
FROM Sellers, Suppliers
WHERE CPF_CNPJ = CNPJ;

-- Relação de produtos, fornecedores e estoques
SELECT PDescription as Produto, SocialName as 'Nome Social', Location as 'Sede do Vendedor', 
	d.Quantity as 'Quantidade em Estoque', StorageLocation as 'Local de Armazenagem'
FROM Products a, ProductSellers b, Sellers c, StorageProducts d, ProductStorages e
WHERE a.idProduct = b.idProduct AND b.idSeller = c.idSeller 
	AND a.idProduct = d.idProduct AND d.idStorage = e.idStorage;

-- Relação de nomes dos fornecedores e nomes dos produtos
SELECT SocialName as 'Nome Social', PDescription as Produto
FROM Products a, ProductSellers b, Sellers c
WHERE a.idProduct = b.idProduct AND b.idSeller = c.idSeller
ORDER BY 1;
    
SELECT PDescription, Price FROM Products
ORDER BY Price DESC
LIMIT 10; 

-- Relação de Tereceiro-Vendedores
SELECT SocialName as 'Terceiro-Vendedor', EntityType,
	IF(EntityType='CNPJ', 
		CONCAT(LEFT(CPF_CNPJ,2), '.', LEFT(RIGHT(CPF_CNPJ,12),3),'.',LEFT(RIGHT(CPF_CNPJ,9),3),'/',LEFT(RIGHT(CPF_CNPJ,6),4),'-',RIGHT(CPF_CNPJ,2)), 
		CONCAT(LEFT(CPF_CNPJ,3), '.', LEFT(RIGHT(CPF_CNPJ,8),3),'.',LEFT(RIGHT(CPF_CNPJ,5),3),'-',RIGHT(CPF_CNPJ,2)))
	as 'Cadastro'
FROM Sellers;

-- Maiores compradores (clientes)
SELECT CONCAT(FirstName,' ', MiddleNameInits,' ', LastName) as 'Nome Completo',
    ROUND(SUM(Price),2) as 'Valor Compras'
FROM Clients a, Payments b, Orders c, ProductOrders d, Products e
WHERE a.idClient = b.idClient AND b.idOrder = c.idOrder AND
	c.idOrder = d.idOrder AND d.idProduct = e.idProduct
GROUP BY a.idClient
ORDER BY 2 DESC;

-- Relação dos produtos mais caros por Categoria
SELECT Category as Categoria, 
	PDescription as Produto, 
    ROUND(AVG(Price),2) as Preço, 
    SUM(Quantity) as Quantidade
FROM Products a, ProductOrders b
WHERE a.idProduct = b.idProduct
GROUP BY Category, PDescription
ORDER BY Category, Preço DESC;

-- Dados consolidados de quantidade e de valores por Categoria
SELECT Category,
	SUM(Quantity) as Quantidade, 
	ROUND(MIN(Price),2) as 'Preço Mínimo',
    ROUND(AVG(Price),2) as 'Preço Médio',
    ROUND(MAX(Price),2) as 'Preço Máximo'
FROM Products a, ProductOrders b
WHERE a.idProduct = b.idProduct
GROUP BY Category
ORDER BY 'Preço Médio' DESC; 

-- Maiores fornecedores em termos de valores dos produtos
SELECT SocialName, SUM(Price) as 'Valor Total'
FROM Products a, ProductSuppliers b, Suppliers c
WHERE a.idProduct = b.idProduct AND b.idSupplier = c.idSupplier
GROUP BY 1
ORDER BY 2 DESC;

-- Produtos sem estoque
SELECT PDescription, Price, Score, Quantity, idStorage
FROM Products a
LEFT JOIN StorageProducts b ON a.idProduct=b.idProduct
WHERE idStorage IS NULL
ORDER BY Price DESC; 

-- Produtos sem estoque
SELECT PDescription, Price, Score, Quantity, idStorage
FROM Products a
LEFT JOIN StorageProducts b ON a.idProduct=b.idProduct
WHERE idStorage IS NULL
ORDER BY Price DESC; 

-- Produtos mais bem avaliados
SELECT PDescription, ROUND(AVG(Score),2) as Avaliação, ROUND(AVG(Price),2) as Preço
FROM Products
GROUP BY 1
HAVING Avaliação >= 4.8
ORDER BY 2 DESC;
