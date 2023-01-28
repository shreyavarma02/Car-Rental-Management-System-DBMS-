import streamlit as st
import pandas as pd
from database import view_all_tables,execute_query
def run_query():
    #st.markdown("# Run Query")
    #sqlite_dbs = [file for file in os.listdir('.') if file.endswith('.db')]
    tables= view_all_tables()
    #st.success('yes')
    #list_of_tables=[i[0] for i in view_all_tables()]
    #selected_table = st.selectbox('DB Filename',list_of_tables )

    #query = st.text_area("SQL Query", height=100)

    #submitted = st.button('Run Query')

    '''if submitted:
        try:
            query= execute_query(query)
            cols = [column[0] for column in query.description]
            results_df= pd.DataFrame.from_records(
                data = query.fetchall(), 
                columns = cols
            )
            st.dataframe(results_df)
        except Exception as e:
            st.write(e)'''
    query = st.text_area("SQL Query", height=100)
    if st.button("Run query"):
        #amount = st.number_input("amount:")
        st.success(query)
        query=execute_query(query)
        '''st.success(query)
        cols = [column[0] for column in query.description]
        results_df= pd.DataFrame.from_records(
            data = query.fetchall(), 
            columns = cols
        )
        st.dataframe(results_df)
        st.success(df)'''