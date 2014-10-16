TouchIDPass
===========

TouchIDPass是一个用TouchID来简化用户认证的第三放库。


》FAQ:
1.什么是TouchIDPass？
TouchIDPass是一个用TouchID来简化用户认证的第三放库。通过在你的app中集成这个库，用户可以通过TouchID进行登录、验证等操作，而不必输入繁琐的账号信息或验证码，极大的简化了用户的操作。

2.TouchIDPass的原理是什么？
将TouchID作为一种令牌，经过你的授权后，TouchID就可以作为你app中的用户认证。当然，用户第一次使用TouchID时还是需要用传统的方式（如输入账号）来验证，然后就可以将其授权。授权信息是经过加密的，并且每个app只可能有一个令牌。

3.如果使用？
请查看目录中的示例代码。



》注意事项:
只支持TouchID的苹果设备，并且系统版本需要iOS8及以上。



》免责声明：
这个第三方库作者为detecyang，并且是开源、免费的。任何个人、公司、组织机构都有权使用，但请在您的项目中注明使用了detecyang的TouchIDPass。另外，由于是开源项目，任何人都可以维护此SDK，由于此SDK导致的财产损失和法律纠纷等问题由您本人承担，detecyang并不负责。
