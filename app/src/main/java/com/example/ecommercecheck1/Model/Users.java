package com.example.ecommercecheck1.Model;

public class Users {
    private String name, phoneno, password;

    public Users()
    {

    }

    public Users(String name, String phoneno, String password, String confirmpassword) {
        this.name = name;
        this.phoneno = phoneno;
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhoneno() {
        return phoneno;
    }

    public void setPhoneno(String phoneno) {
        this.phoneno = phoneno;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }


}
