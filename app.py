import streamlit as st
from create import create
from database import create_table
from delete import delete
from read import read
from update import update
from run import run_query
def main():
    st.title("Car Rental system")
    menu = ["Add", "View", "Edit", "Remove","Run_query"]
    choice = st.sidebar.selectbox("Menu", menu)
    create_table()
    if choice == "Add":
        st.subheader("Enter Vehicle Details:")
        create()
    elif choice == "View":
        st.subheader("View created tasks")
        read()
    elif choice == "Edit":
        st.subheader("Update created tasks")
        update()
    elif choice == "Remove":
        st.subheader("Delete created tasks")
        delete()
    elif choice == "Run_query":
        st.subheader("Run query")
        run_query()
    else:
        st.subheader("About tasks")
if __name__ == '__main__':
    main()