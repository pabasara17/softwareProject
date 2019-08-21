package com.example.ecommercecheck1;

import android.app.ProgressDialog;
import android.content.Intent;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.example.ecommercecheck1.Model.Users;
import com.example.ecommercecheck1.Prevalent.Prevalent;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import io.paperdb.Paper;

public class LoginActivity extends AppCompatActivity {

    private EditText Phoneno,Password;
    private Button LoginButton;
    private ProgressDialog loadingBar;
    private TextView AdminLink,NotAdminLink;

    private String parentDbName ="Users";

    //private CheckBox chkRememberMe;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);



        LoginButton= (Button) findViewById(R.id.logbtn1);
        Password= (EditText) findViewById(R.id.et2passwordlog);
        Phoneno = (EditText) findViewById(R.id.et1phonenolog);
        AdminLink =(TextView) findViewById(R.id.LogAdmin);
        NotAdminLink =(TextView) findViewById(R.id.LogNotAdmin);
        loadingBar = new ProgressDialog(this);



        //chkRememberMe = (CheckBox)findViewById(R.id.cb1log);
       // Paper.init(this);

        LoginButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                LoginUser();
            }
        });

        AdminLink.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                LoginButton.setText("Login Admin");
                AdminLink.setVisibility(View.INVISIBLE);
                NotAdminLink.setVisibility(View.VISIBLE);
                parentDbName ="Admins";
            }
        });

        NotAdminLink.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                LoginButton.setText("Login");
                AdminLink.setVisibility(View.VISIBLE);
                NotAdminLink.setVisibility(View.INVISIBLE);
                parentDbName ="Users";
            }
        });

    }



    private void LoginUser() {
        String phoneno = Phoneno.getText().toString();
        String password = Password.getText().toString();


            if(TextUtils.isEmpty(phoneno))
            {
            Toast.makeText(this, "please enter your phone number", Toast.LENGTH_SHORT).show();
            }
            else if(TextUtils.isEmpty(password))
            {
                Toast.makeText(this, "please enter your phone password", Toast.LENGTH_SHORT).show();

            }
            else{
                loadingBar.setTitle("Login Account");
                loadingBar.setMessage("please wait,while we are checking the credentials");
                loadingBar.setCanceledOnTouchOutside(false);
                loadingBar.show();

                AllowAccesstoAccount(phoneno,password);

            }

    }

    private void AllowAccesstoAccount(final String phoneno, final String password)
    {
       /* if(chkRememberMe.isChecked())
        {
            Paper.book().write(Prevalent.UserPhoneKey, phoneno);
            Paper.book().write(Prevalent.UserPasswordKey, password);
        }*/

        final DatabaseReference RootRef;
        RootRef = FirebaseDatabase.getInstance().getReference();

        RootRef.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot)
            {

                if(dataSnapshot.child(parentDbName).child(phoneno).exists())
                {

                    Users usersData=dataSnapshot.child(parentDbName).child(phoneno).getValue(Users.class);

                    if(usersData.getPhoneno().equals(phoneno))
                    {
                        if(usersData.getPassword().equals(password))
                        {
                            if(parentDbName.equals("Admins"))
                            {
                                Toast.makeText(LoginActivity.this, "Welcome Admin..You are Logged in Successfully", Toast.LENGTH_SHORT).show();
                                loadingBar.dismiss();

                                Intent i=new Intent(LoginActivity.this,AdminCategoryActivity.class);
                                startActivity(i);
                            }
                            else if(parentDbName.equals("Users"))
                            {
                                Toast.makeText(LoginActivity.this, "Logged in Successfully", Toast.LENGTH_SHORT).show();
                                loadingBar.dismiss();

                                Intent i=new Intent(LoginActivity.this,HomeActivity.class);
                                startActivity(i);
                            }

                        }
                        else
                            {
                                loadingBar.dismiss();
                                Toast.makeText(LoginActivity.this, "Password is incorrect", Toast.LENGTH_SHORT).show();
                             }
                    }

                }
                else
                    {
                    Toast.makeText(LoginActivity.this, "Account with this" +phoneno+"do not exists", Toast.LENGTH_SHORT).show();
                    loadingBar.dismiss();


                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });

    }
}
