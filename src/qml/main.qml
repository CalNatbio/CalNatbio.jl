//add borda combobox + botão

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 
import QtQuick.Dialogs 
import org.julialang

ApplicationWindow {
    width: 640
    height: 480
    title: "CalNatBio"
    x: (Screen.width - width) / 2 // Centralizar horizontalmente
    y: (Screen.height - height) / 2 // Centralizar verticalmente
    minimumWidth: 640
    maximumWidth: 640
    minimumHeight: 480
    maximumHeight: 480
    visible: true

    // Define as váriveis globais para uso no APP
    property string conclusionText: "" // Nova propriedade para armazenar o texto do resultado
    property var bfixo: [1.0, 2.0] // Nova propriedade para armazenar o texto do resultado
    property var best: [1.0, 2.0] // Nova propriedade para armazenar o texto do resultado
    property var columnVectorsVals: []

    Rectangle {
        id: rectanglebase
        width: parent.width
        height: parent.height
        visible: true

        Image {
            id: backgroundImagetipologia
            source: "images/wallpaper.jpg"
            width: rectanglebase.width
            height: rectanglebase.height // Substitua pelo caminho real da sua imagem
            fillMode: Image.Stretch
            opacity: 0.60
        }

        Text {
            id: textodeobs
            anchors.centerIn: rectanglebase
            anchors.verticalCenterOffset: 220
            text: qsTr("Mediana: árvore com diâmetro a 1.30m do solo, correspondente ao valor da mediana")
            font.pointSize: 10
            font.family: "Arial"
        }

        Rectangle {
            id: reteste
            anchors.centerIn: rectanglebase
            anchors.verticalCenterOffset: -150
            height: 40
            width: 550
            color: "#191970"


            ComboBox {
                id: comboBox2
                anchors.centerIn: reteste
                width: 540
                height: 30

                currentIndex: 0

                // Adicionar as opções de Tipos de Amostragem
                model: ListModel {
                    id: model2
                    ListElement {
                        text: "Tipologia Florestal"
                    }
                    ListElement {
                        text: "Local"
                    }
                }

                contentItem: Text {
                    text: "Nível Hierárquico: " + comboBox2.currentText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 12
                    font.family: "Arial"
                }

                delegate: ItemDelegate {
                    width: comboBox2.width
                    height: comboBox2.height

                    contentItem: Text {
                        text: model.text
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 12
                        font.family: "Arial"
                        padding: 10
                    }
                }
            }
        }

        Rectangle {
            id: reteste2
            anchors.centerIn: rectanglebase
            anchors.verticalCenterOffset: -20
            height: 40
            width: 550
            color: "#191970"

            ComboBox {
                id: comboBox3
                anchors.centerIn: reteste2
                width: 265
                height: 30
                anchors.horizontalCenterOffset: 136
                currentIndex: 0

                // Adicionar as opções de Tipos de Amostragem
                model: ListModel {
                    id: model3
                    ListElement {
                        text: "Mediana"
                    }
                }

                contentItem: Text {
                    text: "Árvore amostrada: " + comboBox3.currentText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 12
                    font.family: "Arial"
                }

                delegate: ItemDelegate {
                    width: comboBox3.width
                    height: comboBox3.height

                    contentItem: Text {
                        text: model.text
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 12
                        font.family: "Arial"
                        padding: 10
                    }
                }
            }

            ComboBox {
                id: comboBox4
                anchors.centerIn: reteste2
                width: 265
                height: 30
                anchors.horizontalCenterOffset: -136
                currentIndex: 0

                // Adicionar as opções de Tipos de Amostragem
                model: ListModel {
                    id: model4
                    ListElement {
                        text: "Uma árvore"
                    }
                }

                contentItem: Text {
                    text: "Tamanho da Amostra: " + comboBox4.currentText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 12
                    font.family: "Arial"
                }

                delegate: ItemDelegate {
                    width: comboBox4.width
                    height: comboBox4.height

                    contentItem: Text {
                        text: model.text
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 12
                        font.family: "Arial"
                        padding: 10
                    }
                }
            }
        }

        Rectangle{
            id: rectangleinput
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 60
            width: 380
            height: 40
            color: "#0b0b64"

            Grid {
                id: inputDataTipologia
                columns: 2
                anchors.centerIn: parent
                spacing: 10

                // Adicione 18 campos de entrada (TextField)
                Repeater {
                    model: 2
                    TextField {
                        placeholderText: (index % 2 === 0) ? "Dap (cm)" : (index % 2 === 1) ? "Biomassa Total (Kg)" : ""
                        horizontalAlignment: Text.AlignHCenter
                        width: 180
                        height: 30
                        font.pointSize: 12
                        validator: RegularExpressionValidator{
                            regularExpression: /^\d*\.?\d+(,\d+)?$/
                        }

                        Connections {
                            onTextChanged: {
                                if (text.includes(",")) {
                                    text = text.replace(/,/g, ".")
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle{
            id: rectanglebutton
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 180
            width: 310
            height: 36
            color: "#0b0b64"

            Button {
                id: processtipoFlorestal
                text: qsTr("Calibrar Equação")
                width: 300
                font.family: "Arial"
                font.pointSize: 12
                anchors.centerIn: parent

                Connections {
                    target: processtipoFlorestal
                    onClicked: {
                        busyIndicatorTipologia.running = false //é true

                        var columnVectors = []

                        // Inicializa vetores para cada coluna
                        for (var i = 0; i < inputDataTipologia.columns; i++) {
                            columnVectors.push([])
                        }

                        // Itera pelos filhos do GridLayout
                        for (var j = 0; j < inputDataTipologia.children.length; j++) {
                            // Adiciona os valores dos TextField aos vetores correspondentes
                            if (inputDataTipologia.children[j] instanceof TextField) {
                                var columnIndex = j % inputDataTipologia.columns
                                var textValue = inputDataTipologia.children[j].text.trim(
                                            )
                                // Remove espaços em branco

                                // Verifica se o valor é vazio ou nulo
                                if (textValue === "") {
                                    emptyDialogTipoFlorestal.open()
                                    busyIndicatorTipologia.running = false
                                    return
                                    // Aborta o processamento se dados estiverem faltando
                                }

                                columnVectors[columnIndex].push(textValue)
                            }
                        }
                        columnVectorsVals = columnVectors
                        saveDialogTipoFlorestal.open()
                    }
                }
            }
        }
    }

    BusyIndicator {
        id: busyIndicatorTipologia
        width: 90
        height: 90
        running: false
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 190
    }

    // Dialogo para seleção do local de salvamento dos arquivos de resultado
    FileDialog {
        id: saveDialogTipoFlorestal
        title: "Selecione o local para salvar o arquivo..."
        fileMode: FileDialog.SaveFile

        Connections {
            target: saveDialogTipoFlorestal
            onAccepted: {
                var resultado = Julia.ajustarEq(columnVectorsVals, saveDialogTipoFlorestal.selectedFile, comboBox2.currentIndex)

                bfixo = resultado[0]
                best = resultado[1]

                conclusionDialogTipoFlorestal.open()

                busyIndicatorTipologia.running = false
            }
            onRejected: {
                busyIndicatorTipologia.running = false
            }
        }

        Component.onCompleted: visible = false
    }

    // Dialogo de conclusão do processamento
    MessageDialog {
        id: conclusionDialogTipoFlorestal
        title: "Calibração Concluída com Sucesso"
        buttons: MessageDialog.Ok
        text: "Coeficientes estimados, parte aleatória \nb0 = " + bfixo[0] + "\nb1 = "
        + bfixo[1] + "\n\nCoeficientes calibrados \nβ0 = " + best[0] + "\nβ1 = " + best[1]
    }

    // Dialogo de FALTA DE DADOS
    MessageDialog {
        id: emptyDialogTipoFlorestal
        title: "Dados insuficientes para Calibração"
        text: "Os dados informados são insuficientes para a calibração.\nPreencha todos os campos e tente novamente."
        buttons: MessageDialog.Ok
    }

    Connections {
        target: tipologiaFlorestal
        onClosing: {
            for (var i = 0; i < inputDataTipologia.columns; i++) {
                for (var j = 0; j < inputDataTipologia.children.length; j++) {
                    if (inputDataTipologia.children[j] instanceof TextField) {
                        inputDataTipologia.children[j].text = ""
                    }
                }
            }
            comboBox2.currentIndex = 0
        }
    }
}
