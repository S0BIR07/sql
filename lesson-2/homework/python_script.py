import pyodbc
conn_str = 'DRIVER={SQL Server};SERVER=your_server_name;DATABASE=your_database_name;UID=your_username;PWD=your_password'
conn = pyodbc.connect(conn_str)
cursor = conn.cursor()
cursor.execute("SELECT photo FROM photos WHERE id = 1")
row = cursor.fetchone()
if row:
    image_data = row[0]
    with open('retrieved_image.jpg', 'wb') as file:
        file.write(image_data)
    print("Image saved successfully as 'retrieved_image.jpg'.")
else:
    print("No image found with the specified ID.")
cursor.close()
conn.close()