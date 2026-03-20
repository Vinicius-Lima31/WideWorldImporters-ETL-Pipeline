import streamlit as st
import pandas as pd
import numpy as np
import time
from sqlalchemy import create_engine, text

#Importando o arquivo Jupiter (ETL_WideWorldImporters.ipynb)
from importnb import Notebook
# Executar uma única vez e deixar guardado no cache tudo
@st.cache_resource
def carregarJupiter():
    try:
        with Notebook():
            import ETL_WideWorldImporters as etl
        return etl

    except Exception as e:
        print(f"Erro Critio {e}")
        return False

# Executando a importação | Em caso de erro retorna False
etl = carregarJupiter()

# Descrição 
st.markdown("""
## 📎 ETL - WideWorldImporters
Aplicação de um processo automatizado, realizando a extração de dados do banco 
**WideWorldImporters** com foco no nicho de vendas. O projeto realiza o tratamento completo 
de cada tabela (**Dimensões** e **Fato**), garantindo a integridade da informação.

### 🛠️ Data Warehouse (Camada Ouro)
Os dados tratados são persistidos em um Data Warehouse, onde novos registros são inseridos 
de forma segura. O pipeline gerencia a conexão e fornece um detalhamento (logs) de todas 
as ações tomadas durante a carga.

Posteriormente esses registros inseridos no **Data Warehouse** serão usadas para criação de **DASHBOARDS** no :orange[**Power BI**].

🚀 Clique em :green[Executar] para iniciar o processamento dos dados.
""")

st.write("")

# Adicionando uma logo para Sidebar, uma pequena Engrenagem
st.logo(
    "img/Engrenagem.webp",
    link="https://app.powerbi.com/view?r=eyJrIjoiZmVlZDFiZTAtYmFjZi00YTVjLTk3ZDItMDJjYzQ3MDczNDQ0IiwidCI6ImQ0ZmQ2MjE4LTg0MjQtNGFhMy05M2EzLTBlMTI3NDNkYWZjYiJ9",
    icon_image="img/Engrenagem.webp",
)

# Titulo SideBar
st.sidebar.title("⚙️ Painel de Controle")
st.sidebar.caption("Este painel é a interface de monitoramento e execução do pipeline de dados. A lógica de processamento reside no núcleo Jupyter Notebook.")

# Buscando data da ultima atualização do LOG
def data_ultimo_Log():
    try:
        # Buscando na última linha de log, sua Data e Hora
        dataLog = pd.read_sql("""
            SELECT TOP 1 
                Inicio_Data
            FROM 
                [DW_VENDAS].[DW].[Log_DW_VENDAS]
            ORDER BY 
                Fim_Data DESC
        """, etl.conexao_destino)

        # Retornando o formato de string de data no formato (2024-30-11 17:00)
        return str(dataLog.iloc[0,0])[:16]
    
    # Caso o log esteja vazio retorne uma String "Sem Registros"
    except Exception as e:
        return "Sem Registros"

# Buscando o retorno de uma data ou um registro vazio
data_log = data_ultimo_Log()

# Status da Conexão
if etl == False:
    # Se etl retorne False | Servidores estão inativos
    st.sidebar.error("Servidores Offline", icon="⛔")
else:
    # Servidores estão ativos
    st.sidebar.success("Servidores Online ", icon="✔️")
    st.sidebar.caption(f"Última Atualização: {data_log}")

# Caso o Servidor esteja desconectado, não mostrar o botão
if etl != False:

    # Travando Botão após ser clicado (Template)
    # 1. Inicializar estado
    if 'btn_disabled' not in st.session_state:
        st.session_state.btn_disabled = False

    # 2. Callback para mudar estado
    def disable_button():
        st.session_state.btn_disabled = True
    
    # Botão para executar toda Persistencia de dados ao Data Warehouse
    if st.button("Executar", disabled=st.session_state.btn_disabled, on_click=disable_button, use_container_width=True):
        with st.status("Buscando dados Brutos", expanded=True) as status:
     
            st.write("Conectando com o servidor SQL Server")

            st.write("Extração de Dados")

            st.write("Transformação de Dados")

            # Executando a função do Jupiter, porém com 'etl.' na frente de tudo
            # Tratando DataFrames
            (   etl.df_produto_final, 
                etl.df_cliente_final, 
                etl.df_vendedor_final, 
                etl.df_geografica_final, 
                etl.df_data_final, 
                etl.df_fatovendas_final) = (

                etl.executar_tratamento_completo(   etl.df_produto, 
                                                    etl.df_cliente, 
                                                    etl.df_vendedor, 
                                                    etl.df_geografica, 
                                                    etl.df_data, 
                                                    etl.df_fatovendas)
                )

            st.write("Executando carga no Data Warehouse")

            # Executando a função do Jupiter, porém com 'etl.' na frente de tudo
            # Subindo para o Data Warehouse
            etl.Carregamento_dw_completo(etl.df_produto_final, 
                                          etl.df_cliente_final, 
                                          etl.df_vendedor_final, 
                                          etl.df_geografica_final, 
                                          etl.df_data_final, 
                                          etl.df_fatovendas_final)
            

            st.write("Sincronização concluída: Dados prontos para Power BI")

            status.update(
                label="ETL - Concluido", state="complete", expanded=False
            )

        # Fechando Conexão
        etl.fecharConexoes()

        # Mensagem de Sucesso
        st.badge("Sucesso", icon=":material/check:", color="green")

        time.sleep(15)

        # Destravando o botão
        st.session_state.btn_disabled = False

        # Limpa o cache
        st.cache_resource.clear()

        # Atualizar Página
        st.rerun()

# Caso o Servidor esteja Desligado
else:
    st.error('Necessário se conectar a um Servidor!', icon="🚨")
    if st.button("Reconectar", use_container_width=True):
        # Limpa o "False" da memória
        st.cache_resource.clear() 
        # Reinicia o script para tentar o import de novo
        st.rerun() 