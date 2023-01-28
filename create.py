import streamlit as st
from database import add_data
def create():
    col1, col2 = st.columns(2)
    with col1:
        vehicle_id = st.text_input("Vehicle id:")
        mileage = st.text_input("Mileage:")
        plate_no=st.text_input("Plate number:")
    with col2:
        vehicle_model = st.text_input("Vehicle model")
        color= st.selectbox("Color", ["Black","Red","Blue","Yellow","White","Grey"])
        
    if st.button("Add Vehicle"):
        add_data(vehicle_id,mileage,plate_no,vehicle_model,color)
        st.success("Successfully added vehicle: {}".format(plate_no))