-- Criação do banco de dados para E-Commerce

drop database Ecommerce;
create database Ecommerce;
use Ecommerce;

-- Criação da tabela Clientes
CREATE TABLE IF NOT EXISTS Clients (
	idClient INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	FirstName VARCHAR(20) NOT NULL,
	MiddleNameInits VARCHAR(5),
	LastName VARCHAR(20),
    CPF CHAR(11) NOT NULL,
	Address VARCHAR(45),
    CEP CHAR(8) NOT NULL,
    BirthDate DATE NOT NULL,
	CONSTRAINT unique_Clients_CPF UNIQUE(CPF)
)
AUTO_INCREMENT = 1;

-- Criação da tabela Produtos
CREATE TABLE IF NOT EXISTS Products (
	idProduct INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	PDescription VARCHAR(45),
	Category ENUM('Eletrônicos', 'Vestuário', 'Alimentos', 'Brinquedos') NOT NULL,
	Price DECIMAL NOT NULL,
	Score FLOAT
);

-- Criação da tabela Pedidos
CREATE TABLE IF NOT EXISTS Orders (
	idOrder INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	OrderStatus ENUM('Em andamento', 'Processando', 'Enviado', 'Entregue') DEFAULT 'Processando',
	OrderDescription VARCHAR(45),
	FreightValue FLOAT,
	Clients_idClient INT NOT NULL,
	CONSTRAINT fk_Orders_idClient FOREIGN KEY (Clients_idClient) REFERENCES Clients(idClient)
);

-- Criação da tabela Pagamentos
CREATE TABLE IF NOT EXISTS Payments (
	idClient INT NOT NULL,
	idOrder INT NOT NULL,
	PaymentType ENUM('Boleto', 'Pix', 'Cartão', 'Dois cartões'),
	AvailableLimit FLOAT,
	PRIMARY KEY (idClient, idOrder),
	CONSTRAINT fk_Payments_Clients FOREIGN KEY (idClient) REFERENCES Clients(idClient),
	CONSTRAINT fk_Payments_Orders FOREIGN KEY (idOrder)  REFERENCES Orders(idOrder)
);

-- Criação da tabela Estoques
CREATE TABLE IF NOT EXISTS ProductStorages (
	idStorage INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	StorageLocation VARCHAR(45)
);

-- Criação da tabela Fornecedores
CREATE TABLE IF NOT EXISTS Suppliers (
	idSupplier INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	SocialName VARCHAR(45) NOT NULL,
	CNPJ CHAR(15) NOT NULL,
    Contact VARCHAR(15) NOT NULL,
    CONSTRAINT unique_Suppliers_CNPJ UNIQUE(CNPJ)
  );
  
  -- Criação da tabela TerceirosVendedores
CREATE TABLE IF NOT EXISTS Sellers (
	idSeller INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	SocialName VARCHAR(255) NOT NULL,
	AbstractName VARCHAR(255) NULL,
	EntityType ENUM('CNPJ', 'CPF') NOT NULL,
	CPF_CNPJ VARCHAR(14) NOT NULL,
	Location VARCHAR(45) NOT NULL,
	Contact VARCHAR(45) NOT NULL,
	CONSTRAINT unique_Sellers_SocialName UNIQUE(SocialName),
	CONSTRAINT unique_Sellers_CPF UNIQUE(CPF_CNPJ)
 );
 
 -- Criação da tabela ProdutosPorVendedor
 CREATE TABLE IF NOT EXISTS ProductSellers (
	idSeller INT NOT NULL,
	idProduct INT NOT NULL,
	Quantity INT DEFAULT 1,
	PRIMARY KEY (idSeller, idProduct),
	CONSTRAINT fk_ProductSellers_Sellers FOREIGN KEY (idSeller) REFERENCES Sellers(idSeller),
	CONSTRAINT fk_ProductSellers_Products FOREIGN KEY (idProduct) REFERENCES Products(idProduct)
    );
    
-- Criação da tabela ProdutosPorFornecedor
CREATE TABLE IF NOT EXISTS ProductSuppliers (
	idProduct INT NOT NULL,
	idSupplier INT NOT NULL,
	PRIMARY KEY (idProduct, idSupplier),
    CONSTRAINT fk_Product_Suppliers_Products FOREIGN KEY (idProduct) REFERENCES Products(idProduct),
    CONSTRAINT fk_Product_Suppliers_Suppliers FOREIGN KEY (idSupplier) REFERENCES Suppliers(idSupplier)
);

-- Criação da tabela ProdutosEmEstoque
CREATE TABLE IF NOT EXISTS StorageProducts (
    idProduct INT NOT NULL,
    idStorage INT NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (idProduct , idStorage),
    CONSTRAINT fk_StorageProducts_Products FOREIGN KEY (idProduct) REFERENCES Products (idProduct),
    CONSTRAINT fk_StorageProducts_ProductStorages FOREIGN KEY (idStorage) REFERENCES ProductStorages (idStorage)
);

-- Criação da tabela ProdutosPorPedido
CREATE TABLE IF NOT EXISTS ProductOrders (
  idProduct INT NOT NULL,
  idOrder INT NOT NULL,
  Quantity INT DEFAULT 1,
  ProductOrderStatus ENUM('Disponível', 'Fora de estoque') DEFAULT 'Disponível',
  PRIMARY KEY (idProduct, idOrder),
  CONSTRAINT fk_Product_Orders_Products FOREIGN KEY (idProduct) REFERENCES Products(idProduct),
  CONSTRAINT fk_Product_Orders_Orders FOREIGN KEY (idOrder) REFERENCES Orders(idOrder)
);

DESC Clients;
SHOW TABLES;
SHOW DATABASES;
USE information_schema;
SHOW TABLES;
SELECT * FROM referential_constraints;