    module CalNatbio

    # Importa os pacotes utilizados para desenvolvimento e funcionamento do programa
    using QML
    using LinearAlgebra
    using Statistics
    using Plots
    import Base: redirect_stderr


    # Exporta a função Inventory possibilitando ser chamada via terminal pelo usuário
    export RunApp

        # Define a função de ajuste de equação
        function ajustarEq(Dados, save, nivel)
            # Converte o vetor de dados de QVariat para um Vetor de Strings do Julia
            Dados = convert.(Vector{String}, Dados)

            # Converte o vetor de dados em duas variáveis
            DAP = Meta.parse.(Dados[1])
            B = Meta.parse.(Dados[2])

            # Confere se o URL para salvar o resultado é diferente de nulo
            if save !== nothing
                save_s = QString(save)
            else 
                return 0
            end

            # Remover o prefixo "file:///"
            cleaned_path = replace(save_s, "file:///" => "")

            # Remove o sufixo da URL (extensão caso selecionada)
            cleaned_path = split(cleaned_path, ".")[1]

            # Inícia as variáveis em um escopo superior
            b = nothing
            Bhat = nothing

            # Define o DAP máximo para o grid
            if maximum(DAP) <= 45
                maxX = 45
            else
                maxX = ceil((maximum(DAP)/10))*10
            end

            # Ajuste das equações a nível de Tipologia Florestal
            if nivel == 0
                Bfixo=[-1.9106; 2.2598]
                D=[0.022420 -0.011190; -0.011190 0.011420]
                R = [0.1453]
                n=size(DAP,1)
                R=diagm(repeat(R, inner = n))
                Z= log.(DAP)
                Z=[ones(n) Z]
                yhat = Z*Bfixo
                RES= log.(B).-yhat
                RES = 1.11277354479002
                b=D*Z'*inv(Z*D*Z'+R)*RES
                b[1] = b[1] + (R[1,1]/2)
                Bfixo[1] = Bfixo[1] + (R[1,1]/2)
                Bhat=Bfixo+b
                x0= 5:0.001:maxX
                xGrid = [ones(size(x0,1)) x0]
                xGridt = [ones(size(x0,1)) log.(x0)]
                yestimado = xGridt*Bhat
                yestimado = exp.(yestimado)

            # Ajuste das equações a nível de local
            elseif nivel == 1
                Bfixo=[-1.7698; 2.2003]
                D=[0.3263 -0.1483; -0.1483 0.0668]
                R =[0.1575]
                n=size(DAP,1)
                R=diagm(repeat(R, inner = n))
                Z= log.(DAP)
                Z=[ones(n) Z]
                yhat = Z*Bfixo
                RES=log.(B)-yhat
                b=D*Z'*inv(Z*D*Z'+R)*RES
                b[1] = b[1] + (R[1,1]/2)
                Bfixo[1] = Bfixo[1] + (R[1,1]/2)
                Bhat=Bfixo+b
                x0= 5:0.001:maxX
                xGrid = [ones(size(x0,1)) x0]
                xGridt = [ones(size(x0,1)) log.(x0)]
                yestimado = xGridt*Bhat
                yestimado = exp.(yestimado)
            else
                return 0
            end


            # Gerá os gráficos com os paramêtros selecionados
            plt = scatter(DAP, B, xlabel = "Diâmetro à altura do peito (cm)", ylabel = "Biomassa Total (Kg)", grid_linewidth = 0, color = "green", label = false,  xticks = (0:5:maxX))
            plt = plot!(xGrid[:, 2], yestimado, ylim = (0, maximum(yestimado) + 0.1 * (maximum(yestimado))), label = false) 
        
            # Apresenta o gráfico de resutados
            display(plt)

            # Salva o gráfico atribuido ao plt
            savefig("$(cleaned_path).png")

            # Retorna os valores de b e Bhat
            return [round.(b, digits = 3), round.(Bhat, digits = 3)]
        end

        # Ativa o programa em QML
        function RunApp()
                    
            # Redefinindo a saída padrão e de erro para um dispositivo nulo
            #old_stdout = redirect_stdout(devnull)
            old_stderr = redirect_stderr(devnull)

            # Restaurando a saída padrão e de erro
            #redirect_stdout(old_stdout)
            redirect_stderr(old_stderr)

            # Exporta as funções definidas em Julia para o arquivo .QML
            @qmlfunction ajustarEq

            # Atribui o diretório atual dos arquivos a uma variável
            current_directory = dirname(@__FILE__)

            # Carrega o arquivo .qml localizado no diretório atual
            loadqml(joinpath(current_directory, "qml", "main.qml"))
            # Executa o arquivo .QML localizado e carregado anteriormente
            exec()
        end
    end
