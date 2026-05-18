# 🛒 E-Commerce Database Schema

Este repositório contém o **Projeto Lógico de Banco de Dados** para um *E-commerce*. O objetivo é fornecer um exemplo inicial de uma infraestrutura relacional que gerencie desde o cadastro descentralizado de clientes e vendedores (Pessoa Física e Jurídica) até o controle de múltiplos estoques regionais, processamento de pedidos e fluxos de pagamentos.

A modelagem foi desenvolvida com um pouco de integridade referencial, *constraints* de unicidade para prevenção de conflitos e projetada com carga de dados distribuídos geograficamente pelo Brasil.

---

## 📐 Modelo Conceitual e Arquitetura Relacional

O esquema lógico é composto por **7 tabelas principais** e **4 tabelas associativas (N:M)** para gerenciamento de relacionamentos complexos:

                                                      [ Suppliers ]
                                                           |
                                                           |  (1:N)
                                                           v
                                                  [ ProductSuppliers ]
                                                           |
                                                           | (N:1)
                                                           v
    [ ProductStorages ] ---> [ StorageProducts ] ---> [ Products ] <--- [ ProductSellers ] <--- [ Sellers ]
             (1:N)                 (N:1)                   |       (N:1)                   (N:1)
                                                           | (1:N) 
                                                           v
                                                    [ ProductOrders ]
                                                           |
                                                           | (N:1)
                                                           v
                                                      [ Orders ] 
                                                           |
                                                           | (1:N)
                                                           v
                                                     [ Payments ]
                                                           |
                                                           | (N:1)
                                                           v
                                                      [ Clients ]

---

## 🗂️ Detalhamento das Tabelas e Regras de Negócio

### 1. Gestão de Clientes e de Vendedores
*   **`Clients`**: Centraliza os compradores do e-commerce. Possui restrição de unicidade no **CPF**.
*   **`Sellers`**: Estrutura híbrida flexível (polimorfismo). Permite o cadastro tanto de **Pessoas Jurídicas** (exigindo as colunas `SocialName`, `AbstractName` e `CNPJ`) quanto de **Pessoas Físicas** (utilizando a coluna `CPF`).
*   **`ProductSellers`**: Tabela de junção que mapeia quais vendedores oferecem quais e quantos produtos, permitindo múltiplos vendedores por produto ou múltiplos produtos por vendedor.

### 2. Catálogo de Produtos e Fornedecores
*   **`Products`**: Armazena os produtos mapeados por categorias usando-se `ENUM` (`Eletrônicos`, `Vestuário`, `Alimentos`, `Brinquedos`).
*   **`Suppliers`**: Cadastro corporativo dos fornecedores dos produtos.
*   **`ProductSuppliers`**: Tabela de junção que mapeia quais fornecedores entregam quais produtos, permitindo múltiplos fornecedores por produto ou múltiplos produtos por fornecedor.

### 3. Pedidos e Pagamentos
*   **`Orders`**: Registra as intenções de compra dos clientes, gerenciando o ciclo de vida do pedido mediante um `ENUM` de status (`Processando`, `Em andamento`, `Enviado`, `Entregue`).
*   **`ProductOrders`**: Itens que compõem o pedido. Controla a quantidade comprada e faz a verificação de disponibilidade de estoque por item (`Disponível` ou `Fora de Estoque`).
*   **`Payments`**: Fluxo financeiro associado ao pedido. Suporta variadas modalidades através de `ENUM` (`Boleto`, `Pix`, `Cartão`, `Dois cartões`) e monitora o limite disponível de cada cliente para fins de conciliação.

### 4. Logística
*   **`ProductStorages`**: Centraliza os centros de distribuição, espalhados por todo o território nacional (Sudeste, Nordeste, Sul, Centro-Oeste e Norte).
*   **`StorageProducts`**: Tabela de controle de inventário. Cruza o estoque físico dos galpões com o catálogo de produtos e gerencia a quantidade (coluna `Quantity`).

---

## 📊 Volume e Contexto dos Dados Inseridos

O banco de dados acompanha scripts de população  projetados para simular um ambiente de produção real:

| Tabela | Volume de Linhas | Escopo do Contexto Geográfico / Operacional |
| :--- | :---: | :--- |
| `Clients` | **100** | Clientes com endereços distribuídos por todas as capitais estaduais do Brasil. |
| `Products` | **204** | Itens diversificados com nomes comerciais, preços reais e notas de avaliação. |
| `Orders` | **200** | Pedidos distribuídos exclusivamente para a carteira de clientes. |
| `Payments` | **200** | Transações financeiras mapeadas para pedidos ativos com valores de limite. |
| `ProductStorages`| **10** | Centros de Distribuição divididos por cotas regionais (4 SE, 3 NE, 1 S, 1 CO, 1 N). |
| `Suppliers` | **51** | Fornecedores industriais portando CNPJs e contatos telefônicos. |
| `Sellers` | **25** | Lojas corporativas (PJ) e vendedores autônomos (PF). |
| `ProductSellers` | **250** | Matriz de ofertas de produtos associada aos vendedores cadastrados. |
| `ProductSuppliers`| **530** | Vínculos de fornecimento de produtos. |
| `StorageProducts` | **536** | Distribuição física das quantidades de mercadorias estocadas nos 10 galpões. |
| `ProductOrders` | **300** | Quebra detalhada dos itens de consumo vinculados a cada ordem de compra enviada. |

---

## 🚀 *Queries* de Análise

- Pedidos realizados por cliente?
- Vendedor e fornecedor?
- Relação de produtos, fornecedores e estoques?
- Relação de nomes dos fornecedores e nomes dos produtos?
- Relação de Terceiros-Vendedores?
- Maiores compradores (clientes)?
- Relação dos produtos mais caros por Categoria?
- Dados consolidados de quantidade e de valores por Categoria?
- Maiores fornecedores em termos de valores dos produtos?
- Produtos sem estoque?
- Produtos sem estoque?
- Produtos mais bem avaliados?

---
*Projeto desenvolvido como parte dos estudos práticos do curso "Construindo seu Primeiro Projeto Lógico de Banco de Dados" do DIO (https://web.dio.me).*
