import pandas as pd
import streamlit as st
from database import view_all_data, view_only_plate_no, get_vehicle, edit_vehicle_data
def update():
    result = view_all_data()
    df = pd.DataFrame(result, columns=['vehicle_id','mileage','plate_no','vehicle_model','color'])
    with st.expander("Current vehicles"):
        st.dataframe(df)
    list_of_vehicles = [i[0] for i in view_only_plate_no()]
    selected_vehicle = st.selectbox("Vehicle to Edit", list_of_vehicles)
    selected_result = get_vehicle(selected_vehicle)
    if selected_result:
        vehicle_id = selected_result[0][0]
        mileage = selected_result[0][1]
        plate_no = selected_result[0][2]
        vehicle_model = selected_result[0][3]
        color = selected_result[0][4]
        
        col1, col2 = st.columns(2)
        with col1:
            new_vehicle_id = st.text_input("Vehicle id:",vehicle_id)
            new_mileage = st.text_input("Mileage:",mileage)
            new_plate_no=st.text_input("Plate number:",plate_no)
        with col2:
            new_vehicle_model = st.text_input("Vehicle model",vehicle_model)
            new_color= st.selectbox(color, ["Black","Red","Blue","Yellow","White","Grey"])
        
        if st.button("Update vehicle"):
            edit_vehicle_data(new_vehicle_id,new_mileage,new_plate_no,new_vehicle_model,new_color, vehicle_id,mileage,plate_no,vehicle_model,color)
            st.success("Successfully updated:: {} to ::{}".format(plate_no, new_plate_no))
        result2 = view_all_data()
    df2 = pd.DataFrame(result2, columns=['vehicle_id','mileage','plate_no','vehicle_model','color'])
    with st.expander("Updated data"):
        st.dataframe(df2)