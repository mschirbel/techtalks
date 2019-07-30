# Principles of Chaos Engineering

Teremos 3 partes principais:

1. Definições e Aspectos Teóricos
2. Algumas Ferramentas e suas capacidades
3. Case de estudo - Netflix

## Definições e Aspectos Teóricos

Primeiramente precisamos definir o que é Caos, pois esse será o objeto do nosso estudo. Caos vem do grego χά.ος[1], que significa um estado de comportamentos aleatórios de um sistema. Este sistema, está sujeito a mudanças e a alterações em seu comportamento.[2]

Logo, temos que Engenharia, ou ciência do Caos, é o estudo sobre como podemos controlar e analisar o caos sobre um sistema determinístico. Ao provocarmos essa turbulência, testamos a confiabilidade do sistema em produção.

## História do Chaos Engineering

Em 2010 Netflix lançou o Chaos Monkey, o primeiro membro da Simian Army [3] E a partir daí, outras ferramentas foram lançadas, as quais veremos no decorrer desse estudo. Essa ferramenta só nasceu porque de 2007 a 2009, o site cresceu em 11.000 o número de títulos em seu catálogo[4]. Com toda essa necessidade de escalabilida e confiança no produto, o time decidiu que era hora de testar a resiliência do sistema. E com a migração para cloud, tudo ficou ainda mais fácil.

## Princípios de Chaos Engineering

E assim fomos capazes de perceber certos aspectos necessários ao se implantar Chaos Engineering em um sistema. E compilamos essas ideias em alguns princípios. Todos eles estão descritos no site do PrinciplesOfChaos.org[5]

### Tenha um estado padrão bem definido

Esse estado deve contar com alguma saída esperada. E para isso, deve-se ter um sistema de métricas bem definido. Com a capacidade de olhar sobre o sistema de um aspecto macro[6].

Para que isso seja possível, devemos ter um sistema capaz de fazer fallbacks em alta velocidade.
Suponha um serviço A que faça uma chamada a um cache do serviço B. Caso o serviço de cache do serviço B falhe, o serviço A deve ser capaz de reconhecer isso e fazer um fallback, chamando diretamente o serviço B.

As métricas usadas para isso devem estar alinhadas, sempre, com as regras do negócio. Pode ser que uma métrica do Netflix não seja útil para você, o importante é saber indentificar o princípio dentro da sua infraestrutura.

### Use eventos reais para testar suas hipóteses

Erros acontecem. E para testar as hipóteses, devemos ter em mente quais são todas as entradas possíveis do nosso sistema. Para isso, colete dados dos inputs dos usuários e catalogue as causas raízes de problemas do passado. Entretanto, podemos fazer testes ainda mais reais, como:
1. fazer uma instância morrer.
2. fazer um serviço morrer
3. fazer uma request não receber o que deve
4. inutilizar toda uma região na nuvem

Todos esses exemplos podem acontecer, e treinar para reagir bem a eles é o caminho certo[7]. É melhor ter uma recuperação rápida do que saber se previnir.

Mas não se preocupe em inserir todas as causas raíz dos possíveis problema. Porque isso seria um trabalho interminável, é melhor inserir a falha frequentemente e se adaptar aos erros.[8]

### Faça experimentos em produção

Como os sistemas estão em constante mudança, devemos considerar nos testes todo o workload, inputs e possíveis saídas que teremos no ambiente produtivo.[9], pois é impossível determinar todas as possibilidades do sistema.

Ainda assim, devemos considerar o bem-estar dos nossos clientes, ninguém quer que a sessão morra porque alguem estava brincando com algum serviço.[9]. Portanto, podemos utilizar algumas técnicas para termos um controle de grupo confiável e ainda assim testarmos as novas funcionalidades. É o que chamamos de Canary Deployment.

![](https://miro.medium.com/max/700/0*Td5RPXNrgFnRW1KX.)

Com essa técnica, limitamos uma pequena parte do acesso a duas vias: um grupo de controle e um grupo com a nova atualização.A partir dos acessos gerados, estabelecemos uma nota para a nova atualização, com base nas métricas do nosso sistema estável. Se a nota foi maior ou igual a atual, é feito o deploy da nova atualização.


## Bibliografia

[1] Origem da palavra caos - http://michaelis.uol.com.br/busca?r=0&f=0&t=0&palavra=caos
[2] O que é Engenharia do Caos - https://tegra.com.br/2018/10/22/engenharia-do-caos/
[3] Chaos Monkey origem - https://www.gremlin.com/community/tutorials/chaos-engineering-the-history-principles-and-practice/#2010
[4] Brief history of chaos eng. - https://www.itchronicles.com/software-development/chaos-engineering-introduction/
[5] Principios do Caos - https://principlesofchaos.org/
[6] Chaos Engineering, Ali Basiri, Niosha Behnam, Ruud de Rooij, Lorin Hochstein, Luke Kosewski, Justin Reynolds, Casey Rosenthal - https://arxiv.org/pdf/1702.05843.pdf
[7] Chaos Engineering Upgraded - https://medium.com/netflix-techblog/chaos-engineering-upgraded-878d341f15fa
[8] Vary real world examples - https://www.oreilly.com/library/view/chaos-engineering/9781491988459/ch04.html
[9] ChAP - new tool of Netflix - https://medium.com/netflix-techblog/chap-chaos-automation-platform-53e6d528371f
