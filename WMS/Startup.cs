using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CommonLogics;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using WMS.CommonBusinessFunctions;
using WMS.Models.Entities;

namespace WMS
{
    public class Startup
    {
        public IConfiguration Configuration { get; }
        private string _contentRootPath = "";
        public Startup(IConfiguration configuration, IHostingEnvironment env)
        {
            Configuration = configuration;
            Configuration = new ConfigurationBuilder()
            .SetBasePath(env.ContentRootPath)
            .AddJsonFile("settings.json")
            .Build();

            _contentRootPath = env.ContentRootPath;
        }


        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc(option =>
            {
                option.Filters.Add(new AutoValidateAntiforgeryTokenAttribute());
                var policy = new AuthorizationPolicyBuilder()
                .RequireAuthenticatedUser()
                .Build();
                option.Filters.Add(new AuthorizeFilter(policy));
               // option.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;

            }).SetCompatibilityVersion(CompatibilityVersion.Version_2_1);

            services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
                .AddCookie(option =>
                {
                    option.AccessDeniedPath = "/Settings/Denied";
                    option.LoginPath = "/Settings/NotLogIn";
                });


            //services.AddMvc().AddJsonOptions(option =>
            //                option.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
            //);


            services.AddOptions();
            services.Configure <Settings>(Configuration.GetSection("ConnectionStrings"));
            services.AddScoped<CommonFunctions>();
            services.AddScoped<CommonBusinessLogics>();

            //Online Database
            services.AddDbContext<WMSDBContext>(option =>
            option.UseSqlServer(Configuration["ConnectionStrings:DefaultConnection"]));


            //Offline .mdf Database ... Not Work
            //services.AddDbContext<WMSDBContext>(option =>
            //{
            //    string conn = Configuration.GetConnectionString("connection");
            //    string conn = Configuration["ConnectionStrings:connection"];
            //    if (conn.Contains("%root%"))
            //    {
            //        conn = conn.Replace("%root%", _contentRootPath);
            //    }
            //    option.UseSqlServer(conn);
            //});


            //SQLite Database ...
            //services.AddDbContext<WMSDBContext>(option =>
            //{
            //    string conn = Configuration["ConnectionStrings:SQLite"];
            //    if (conn.Contains("%root%"))
            //    {
            //        conn = conn.Replace("%root%", _contentRootPath);
            //    }
            //    option.UseSqlite(conn);
            //});


        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            #region Technical MiddleWare
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseStatusCodePagesWithRedirects("/Technical/{0}");
            }
            #endregion Technical MiddleWare


            #region Security MiddleWare
            //[Note: Not Working. (Investigation needed.)]
            //app.UseForwardedHeaders(new ForwardedHeadersOptions
            //{
            //    ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
            //});
            //[~Note: Not Working. (Investigation needed.)]
            app.UseHttpsRedirection();
            app.Use(async (context, next) =>
            {
                context.Response.Headers.Add("X-Frame-Options", "SAMEORIGIN");
                await next();
            });
            //app.UseHsts(option =>
            //{
            //    option.MaxAge(days: 365).IncludeSubdomains();
            //});
            //app.UseXContentTypeOptions();
            //app.UseXXssProtection(option =>
            //{
            //    option.EnabledWithBlockMode();
            //});
            #endregion Security MiddleWare

            app.UseStaticFiles();

            #region Authentication MiddleWare
            app.UseAuthentication();
            #endregion Authentication MiddleWare

            //app.UseCookiePolicy();

            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=Home}/{action=Home}/{id?}");
            });
        }
    }
}
