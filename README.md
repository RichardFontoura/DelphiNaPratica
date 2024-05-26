<h1 align="center"> Delphi na Prática </h1>

# Índice 

* [Introdução] (# Introdução)
* [Descrição do Projeto] (#Descrição-do-Projeto)
* [Conclusão] (#Conclusão)

# Introdução
Delphi na prática e um projeto feito em Pascal usando a IDE do Delphi. O software e desenvolvido usando as boas práticas de programação com Orientação a Objetos usando herança e polimorfismo.
Também e usado o componente do AcBr para fazer a validação do campo de CNPJ no cadastro de fornecedores.
Outro detalhe é que e utilizado a API da BrasilAPI (https://brasilapi.com.br/docs#tag/CEP), consumir JSON e trazer dados de Endereços para clientes e fornecedores.

#Descrição-do-Projeto
O projeto e um CRUD, o mesmo possui 3 telas, sendo elas:
- Tela Principal - Essa e a tela principal do sistema e nela você entrará os acessos para outras telas:
![Screenshot_1](https://github.com/RichardFontoura/DelphiNaPratica/assets/132071931/7af02e60-56f1-4fef-ad93-472a5db98eaa)
- Cadastro de Cliente - Nessa tela você poderá incluir, alterar, consultar e excluir clientes. Sendo que ao pressionar a tecla ENTER no campo CEP, caso ele estiver devidamente preenchido, o mesmo fara uma requisição na BrasilAPI e trara os dados do CEP digitado.
![Screenshot_2](https://github.com/RichardFontoura/DelphiNaPratica/assets/132071931/2e76c91e-3651-4cdf-be1e-d0c5e99c8dec)
- Cadastro de Fornecedores - Nessa tela você poderá incluir, alterar, consultar e excluir fornecedores. Sendo que ao pressionar a tecla ENTER no campo CEP, caso ele estiver devidamente preenchido, o mesmo fara uma requisição na BrasilAPI e trara os dados do CEP digitado. Outro detalhe e que ao pressionar ENTER no campo CNPJ, caso ele estiver devidamente preenchido, usara o componente do AcBr Validador para validar se o CNPJ digitado pelo usuário segue o padrão brasileiro do mesmo.
- ![Screenshot_3](https://github.com/RichardFontoura/DelphiNaPratica/assets/132071931/4abaff54-95c6-4073-9da2-497edd56ddfe)

Um detalhe e que a Unit UEndereco, que possui a Classe TEndereco, ela serve com "Pai" para as classes de TCliente, TForncedor e TConsultaAPI, ja que a partir dessas classes são criados os Objetos para o controle dos dados de cliente e forncedores.

#Conclusão
O projeto "Delphi na Prática" é um exemplo prático e eficiente de um sistema CRUD. Ele aplica boas práticas de programação orientada a objetos, como herança e polimorfismo, e integra componentes externos para aumentar sua funcionalidade. O uso do AcBr para validação de CNPJ e da API BrasilAPI para consulta de CEP demonstra a capacidade de integração do sistema com serviços externos. Fique a vontade para testar :)
