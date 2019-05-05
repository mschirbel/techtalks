# Extra

Faça um fork desse repositório e suba suas respostas no GitHub.

Os exercícios estão divididos em duas partes:

1. Um container com uma aplicação NodeJS.
2. WordPress com Docker-compose

*Os arquivos da app Node estarão aqui, pode ficar tranquilo.*

## NodeJS Container App

Seu trabalho é:

1. Criar um Dockerfile para a imagem
2. Rodar um container com essa imagem na porta 80.

Lembrando que:

    - Essa aplicação node só escuta a porta 3000.
    - você não pode alterar o código
    - o código a ser usado está na pasta app. Use essa pasta dentro do seu container

Depois que você subir a aplicação, veja que ela sobe com a seguinte mensagem: 'Olá, pessoa'.

Modifique **somente** o seu Dockerfile para que ela apareça com o seu nome.

## WordPress

Suba uma pequena stack de wordpress usando o docker-compose.

Pode usar qualquer versão do apache e do MySQL.

Siga as recomendações:

    - quaisquer variáveis de imagem devem estar no Dockerfile
    - use senha aleatória para o root do MySQL
    - crie um volume para o banco
    - coloque os serviços na mesma rede

Após concluir essa parte, descubra como subir essa stack com múltiplos containers. 2 Para o Web e 3 para o DB. **Você deve usar somente um comando para fazer isso**. 