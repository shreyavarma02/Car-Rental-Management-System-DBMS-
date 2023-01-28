import pandas as pd 
import streamlit as st
from database import view_all_data, view_only_plate_no, delete_data
def delete():
    result = view_all_data()
    df = pd.DataFrame(result, columns=['vehicle_id','mileage','plate_no','vehicle_model','color']) 
    with st.expander("Current data"):
        st.dataframe(df)
    list_of_vehicles = [i[0] for i in view_only_plate_no()] 
    selected_vehicle = st.selectbox("Task to Delete", list_of_vehicles) 
    st.warning("Do you want to delete ::{}".format(selected_vehicle)) 
    if st.button("Delete vehicle"):
        delete_data(selected_vehicle)
        st.success("Vehicle has been deleted successfully")
    new_result = view_all_data()
    df2 = pd.DataFrame(new_result, columns=['vehicle_id','mileage','plate_no','vehicle_model','color']) 
    with st.expander("Updated data"):
        st.dataframe(df2)