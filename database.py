import mysql.connector 
import pandas as pd
import streamlit as st
mydb = mysql.connector.connect(
host="localhost", user="root", password="", database="car_rental"
)
c = mydb.cursor()
def create_table(): 
    c.execute('CREATE TABLE IF NOT EXISTS VEHICLE_DUPLICATE(vehicle_id TEXT,mileage TEXT,plate_no TEXT,vehicle_model TEXT,color TEXT)')
def add_data(vehicle_id,mileage,plate_no,vehicle_model,color): 
    c.execute('INSERT INTO VEHICLE_DUPLICATE(vehicle_id,mileage,plate_no,vehicle_model,color) VALUES (%s,%s,%s,%s,%s)',(vehicle_id,mileage,plate_no,vehicle_model,color)) 
    mydb.commit()
def view_all_data(): 
    c.execute('SELECT * FROM VEHICLE') 
    data = c.fetchall()
    return data
def view_only_plate_no(): 
    c.execute('SELECT plate_no FROM VEHICLE') 
    data = c.fetchall()
    return data
def get_vehicle(plate_no): 
    c.execute('SELECT * FROM VEHICLE WHERE plate_no="{}"'.format(plate_no)) 
    data = c.fetchall()
    return data
def edit_vehicle_data(new_vehicle_id,new_mileage,new_plate_no,new_vehicle_model,new_color, vehicle_id,mileage,plate_no,vehicle_model,color):
    c.execute("SET FOREIGN_KEY_CHECKS=0 ")
    c.execute("UPDATE VEHICLE SET vehicle_id=%s, mileage=%s, plate_no=%s, vehicle_model=%s, color=%s WHERE vehicle_id=%s AND mileage=%s AND plate_no=%s AND vehicle_model=%s AND color=%s ", (new_vehicle_id,new_mileage,new_plate_no,new_vehicle_model,new_color, vehicle_id,mileage,plate_no,vehicle_model,color)) 
    mydb.commit()
    data = c.fetchall()
    return data
def delete_data(plate_no): 
    c.execute('DELETE FROM VEHICLE WHERE plate_no="{}"'.format(plate_no)) 
    mydb.commit()
def view_all_tables():
    c.execute('Show tables')
    data = c.fetchall()
    #st.success('works')
    return data
def execute_query(query):
    c.execute(query)
    cols = [column[0] for column in c.description]
    results_df= pd.DataFrame.from_records(
        data = c.fetchall(), 
        columns = cols
    )
    st.dataframe(results_df)
    return query