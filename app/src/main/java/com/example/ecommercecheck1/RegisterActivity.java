package com.example.ecommercecheck1;

import android.app.ProgressDialog;
import android.content.Intent;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.HashMap;

public class RegisterActivity extends AppCompatActivity {

    private Button CreateAccount;
    private EditText Username, Phoneno, Email, Password, Confirmpassword;
    private ProgressDialog loadingBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);

        CreateAccount = (Button) findViewById(R.id.btncreate);
        Username = (EditText) findViewById(R.id.et1username);
        Phoneno = (EditText) findViewById(R.id.et2phnum);
        Email = (EditText) findViewById(R.id.et3email);
        Password = (EditText) findViewById(R.id.et4paswrd);
        Confirmpassword = (EditText) findViewById(R.id.et5cnfrmpaswrd);
        loadingBar = new ProgressDialog(this);

        CreateAccount.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                setCreateAccount();
            }
        });

    }

    private void setCreateAccount() {
        String name = Username.getText().toString();
        String phoneno = Phoneno.getText().toString();
        String email = Email.getText().toString();
        String password = Password.getText().toString();
        String confirmpassword =Confirmpassword.getText().toString();

        if(TextUtils.isEmpty(name)){
            Toast.makeText(this, "please enter your name", Toast.LENGTH_SHORT).show();
        }
       else if(TextUtils.isEmpty(phoneno)){
            Toast.makeText(this, "please enter your phone number", Toast.LENGTH_SHORT).show();

        }
        else if(TextUtils.isEmpty(email)){
            Toast.makeText(this, "please enter your email", Toast.LENGTH_SHORT).show();

        }
        else if(TextUtils.isEmpty(password)){
            Toast.makeText(this, "please enter your phone password", Toast.LENGTH_SHORT).show();

        }
        else if(TextUtils.isEmpty(confirmpassword)){
            Toast.makeText(this, "please re-enter your password to confirm", Toast.LENGTH_SHORT).show();

        }
        else{
            loadingBar.setTitle("Create Account");
            loadingBar.setMessage("please wait,while we are checking the credentials");
            loadingBar.setCanceledOnTouchOutside(false);
            loadingBar.show();

            ValidatephoneNumber(name,phoneno,password,confirmpassword);


        }


    }

    private void ValidatephoneNumber(final String name, final String phoneno, final String password,final String confirmpassword) {

        final DatabaseReference RootRef;
        RootRef = FirebaseDatabase.getInstance().getReference();

        RootRef.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {

                if(!(dataSnapshot.child("Users").child(phoneno).exists())){

                    HashMap<String, Object> userdataMap = new HashMap<>();
                    userdataMap.put("phoneno",phoneno);
                    userdataMap.put("password",password);
                    userdataMap.put("name",name);
                    userdataMap.put("confirmpassword",confirmpassword);

                    RootRef.child("Users").child(phoneno).updateChildren(userdataMap).addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task) {
                            if(task.isSuccessful()){
                                Toast.makeText(RegisterActivity.this, "Congratulations!Your account has been created", Toast.LENGTH_SHORT).show();
                                loadingBar.dismiss();

                                Intent i=new Intent(RegisterActivity.this,LoginActivity.class);
                                startActivity(i);

                            }
                            else{
                                Toast.makeText(RegisterActivity.this, "Network error try again", Toast.LENGTH_SHORT).show();
                                loadingBar.dismiss();
                            }


                        }
                    });



                }
                else{
                    Toast.makeText(RegisterActivity.this, "This " + phoneno +"already exists", Toast.LENGTH_SHORT).show();
                    loadingBar.dismiss();
                    Toast.makeText(RegisterActivity.this, "please try again using another phone number", Toast.LENGTH_SHORT).show();

                    Intent i=new Intent(RegisterActivity.this,MainActivity.class);
                    startActivity(i);
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });
    }

}