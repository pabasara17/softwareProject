package com.example.ecommercecheck1;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import io.paperdb.Paper;

public class HomeActivity extends AppCompatActivity {

    private Button LogoutButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        LogoutButton = (Button) findViewById(R.id.homeLogoutbtn);

        LogoutButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {

                //Paper.book().destroy();

                Intent i=new Intent(HomeActivity.this,MainActivity.class);
                startActivity(i);
            }
        });


    }
}
