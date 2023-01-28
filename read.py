import pandas as pd
import streamlit as st
import plotly.express as px
from database import view_all_data
def read():
    result = view_all_data()
    # st.write(result)
    df = pd.DataFrame(result, columns=['vehicle_id','mileage','plate_no','vehicle_model','color']) 
    with st.expander("View all Vehicles"):
        st.dataframe(df)
    with st.expander("Color"):
        task_df = df['color'].value_counts().to_frame()
        task_df = task_df.reset_index()
        st.dataframe(task_df)
        p1 = px.pie(task_df, names='index', values='color')
        st.plotly_chart(p1)