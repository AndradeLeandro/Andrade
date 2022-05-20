from re import I

for i in range(1,11,1):
    print(i)


#i = int(input("Digite um valor: ")
#while i < 3:
#    print("Verdadeiro")
#    i += 1

nome = input("Digite seu nome: ")
idade = input("Digite sua idade: ")
print("Meu nome é " + nome + " Minha idade é " + idade)
peso = int(input("Digite seu peso: "))
altura = int(input("Digite sua altura: "))
imc = peso/altura
print ("Seu IMC é:" + imc)
